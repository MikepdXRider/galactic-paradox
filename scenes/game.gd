extends Node2D

# THIS IS A FRAGILE VALUE - CHECK IF SPAWNING POSITION SEEMS OFF
const PLAYER_OFFSET = Vector2(296, 144)

const SAMPLE_ENEMY_SMALL = preload("res://scenes/sample_enemy/SampleEnemy.tscn")

@export var base_mob_time_sec: float = 5
@export var mob_threshold = 10

@onready var mob_timer: Timer = $MobTimer
@onready var mob_path: Path2D = $MobPath
@onready var player: CharacterBody2D = $Player
@onready var mob_spawn_location: PathFollow2D = $MobPath/MobSpawnLocation
@onready var upgrades: CanvasLayer = $Upgrades

var active_mobs = 0


func _process(delta: float) -> void:
	mob_path.global_position = player.global_position - PLAYER_OFFSET


func _ready() -> void:
	upgrades.closed.connect(player.force_gravity_check)
	spawn_mob()
	mob_timer.start(base_mob_time_sec)
	mob_timer.timeout.connect(func():
		spawn_mob()
		# TODO: BE BETTER HERE!!!! GROSS IF ELSE
		if GameState.get_item(GameState.KEYS.AUTOPILOT_ENABLED):
			var autopilot_base_mob_time_sec = base_mob_time_sec * 2
			var adjust = (autopilot_base_mob_time_sec) * (GameState.get_item(GameState.KEYS.MOB_SPAWN_RATE_FACTOR) - 1)
			mob_timer.start(autopilot_base_mob_time_sec - adjust)
		else:
			var adjust = base_mob_time_sec * (GameState.get_item(GameState.KEYS.MOB_SPAWN_RATE_FACTOR) - 1)
			mob_timer.start(base_mob_time_sec - adjust)
	)
	
	
func calculate_mob_threshold() -> float:
	return mob_threshold * GameState.get_item(GameState.KEYS.MOB_COUNT_FACTOR)


func spawn_mob() -> void:
	if active_mobs < calculate_mob_threshold():
		active_mobs += 1
		
		# Create a new instance of the Mob scene.
		var mob = SAMPLE_ENEMY_SMALL.instantiate()
		
		mob.tree_exited.connect(func(): active_mobs -= 1)

		# Choose a random location on Path2D.
		var mob_spawn_location = $MobPath/MobSpawnLocation
		mob_spawn_location.progress_ratio = randf()

		# Set the mob's direction perpendicular to the path direction.
		var direction = mob_spawn_location.global_rotation + PI / 2

		# Set the mob's position to a random location.
		mob.position = mob_spawn_location.global_position

		# Add some randomness to the direction.
		direction += randf_range(-PI / 4, PI / 4)
		mob.rotation = direction

		# Spawn the mob by adding it to the Main scene.
		add_child(mob)
		
		# Choose the velocity for the mob.
		var velocity = Vector2(randf_range(15, 45.00), 0.0)
		mob.linear_velocity = velocity.rotated(direction)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ESCAPE"):
		match upgrades.visible:
			true:
				upgrades.close()
			false:
				get_tree().paused = true
				upgrades.show()


func _on_check_button_toggled(toggled_on: bool) -> void:
	GameState.set_item(GameState.KEYS.AUTOPILOT_ENABLED, toggled_on)
