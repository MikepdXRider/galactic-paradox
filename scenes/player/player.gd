extends CharacterBody2D

# TODO:
# - Extract relevant code to a Ship class
#	- Player class should own a Ship
#	- Player class should handle user input leverage Ship API accordingly
#		- This script detect input, calls relevant methods on ship, ship and child entities handle execution and restrictions


const MAX_SPEED = 30
const ACCELERATION = 10
const DECELERATION = 3
const FIRE_RATE_SEC = 1
const ROTATION_SPEED = 2.5

@export var PRIMARY_PROJECTILE: PackedScene

@onready var barrel: Marker2D = $Barrel
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var gravitational_field: Area2D = $GravitationalField

var _can_fire = true


func _ready() -> void:
	fire_rate_timer.timeout.connect(toggle_can_fire)
	GameState.state_changed.connect(handle_state_change)


func _physics_process(delta: float) -> void:
	if GameState.get_item(GameState.KEYS.AUTOPILOT_ENABLED):
		var possible_target = get_target()
		if possible_target:
			rotation = lerp_angle(rotation, (possible_target.global_position - global_position).angle(), (calculate_rotation_speed() / 2) * delta)
			fire_primary()
	else:
		rotation = lerp_angle(rotation, (get_global_mouse_position() - global_position).angle(), calculate_rotation_speed() * delta)
		
		var input_vector = Vector2.ZERO

		# capture input
		if Input.is_action_pressed("ACC_FRONT"):    # W
			input_vector.x += 1
		if Input.is_action_pressed("ACC_BACK"):  # S
			input_vector.x -= 1
		if Input.is_action_pressed("ACC_LEFT"):  # A
			input_vector.y -= 1
		if Input.is_action_pressed("ACC_RIGHT"): # D
			input_vector.y += 1
		if Input.is_action_pressed("FIRE_PRIMARY"): # LMB
			fire_primary()

		# normalize input vector to ensure consistent movement
		if input_vector != Vector2.ZERO:
			input_vector = input_vector.rotated(rotation).normalized()

			# accelerate toward the input direction
			velocity += input_vector * calculate_acceleration() * delta
			
		if velocity.length() > calculate_max_speed():
			# clamp velocity to max speed
			velocity = velocity.normalized() * calculate_max_speed()
		else:
			# gradual deceleration when no input is provided
			var deceleration_vector = velocity.normalized() * calculate_deceleration() * delta
			if deceleration_vector.length() > velocity.length():
				velocity = Vector2.ZERO
			else:
				velocity -= deceleration_vector

	# use move_and_slide to handle movement and collisions
	# having this outside of the autopilot check 
	# allows ship to maintain velocity if autopilot is enabled 
	move_and_slide()


func handle_state_change(key: GameState.KEYS, value: Variant) -> void:
	match key:
		GameState.KEYS.PLAYER_GRAVITY_SCALE:
			gravitational_field.update_scale(value)


func calculate_max_speed() -> float:
	return MAX_SPEED * GameState.get_item(GameState.KEYS.PLAYER_MOVEMENT_FACTOR)


func calculate_acceleration() -> float:
	return ACCELERATION * GameState.get_item(GameState.KEYS.PLAYER_ACCELERATION_FACTOR)


func calculate_deceleration() -> float:
	return DECELERATION * GameState.get_item(GameState.KEYS.PLAYER_ACCELERATION_FACTOR)


func calculate_rotation_speed() -> float:
	return ROTATION_SPEED * GameState.get_item(GameState.KEYS.PLAYER_ROTATION_SPEED)


func calculate_projectile_speed(base_speed: float) -> float:
	return base_speed * GameState.get_item(GameState.KEYS.PLAYER_PROJECTILE_FACTOR)


func calculate_projectile_dmg(base_dmg: float) -> float:
	return base_dmg * GameState.get_item(GameState.KEYS.PLAYER_DMG_FACTOR)
	

func calculate_fire_rate() -> float:
	return FIRE_RATE_SEC * 2 if GameState.get_item(GameState.KEYS.AUTOPILOT_ENABLED) else FIRE_RATE_SEC


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("FIRE_PRIMARY"):
		fire_primary()


func fire_primary() -> void:
	if _can_fire && PRIMARY_PROJECTILE:
		toggle_can_fire()
		fire_rate_timer.start(calculate_fire_rate())
		launch_projectile(PRIMARY_PROJECTILE)


func launch_projectile(projectile: PackedScene) -> void:
	var new_projectile = projectile.instantiate()
	
	# adjust values	
	new_projectile.base_damage = calculate_projectile_dmg(new_projectile.base_damage)
	new_projectile.speed = calculate_projectile_speed(new_projectile.speed)
	
	# add to root node (we don't own launched projectiles)	
	get_tree().root.add_child(new_projectile)
	
	# set location and direction	
	new_projectile.global_position = barrel.global_position
	new_projectile.rotation = rotation


func toggle_can_fire() -> void:
	_can_fire = !_can_fire


func get_target() -> Variant:
	var mobs =  get_tree().get_nodes_in_group('mob')
	var filtered = mobs.filter(func(mob): return mob.is_on_screen())
	if filtered.size():
		var closest_distance = 10000
		var closest_mob = null
		for mob in filtered:
			var current_distance = mob.global_position.distance_to(global_position)
			if current_distance < closest_distance:
				closest_distance = current_distance
				closest_mob = mob
		return closest_mob
	return null


func force_gravity_check() -> void:
	gravitational_field.handle_overlapping_areas()
