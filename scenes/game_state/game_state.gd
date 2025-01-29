extends Node2D

signal state_changed(key: KEYS, new_value: Variant)

enum KEYS {
	# PLAYER	
	PLAYER_CURRENCY,
	PLAYER_ROTATION_SPEED, # How quickly player turns
	PLAYER_HP_FACTOR, 
	PLAYER_MOVEMENT_FACTOR,
	PLAYER_ACCELERATION_FACTOR,
	PLAYER_PROJECTILE_FACTOR, # SPEED
	PLAYER_DMG_FACTOR,
	PLAYER_CRITICAL_HIT_FACTOR,
	PLAYER_PROJECTILE_PENETRATION,
	PLAYER_GRAVITY_SCALE,
	# MOBS	
	MOB_SPAWN_RATE_FACTOR,
	MOB_COUNT_FACTOR,
	MOB_HP_FACTOR,
	MOB_DMG_FACTOR,
	MOB_CRITICAL_HIT_FACTOR,
	MOB_MOVEMENT_FACTOR,
	MOB_CURRENCY_FACTOR,
	# AI
	AUTOPILOT_ENABLED
}

enum SPAWN_TYPES {
	LOOT,
	MOB,
	ELITE,
	BOSS,
	SUPPLIES
}

const ENUM_TO_TEXT: Dictionary = {
	KEYS.PLAYER_ROTATION_SPEED: "Rotation Speed Factor",
	KEYS.PLAYER_MOVEMENT_FACTOR: "Max Movement Speed Factor",
	KEYS.PLAYER_PROJECTILE_FACTOR: "Projectile Speed Factor",
	KEYS.PLAYER_ACCELERATION_FACTOR: "Acceleration/Deceleration Factor",
	KEYS.PLAYER_DMG_FACTOR: "Projectile Damage Factor",
	KEYS.PLAYER_GRAVITY_SCALE: "Collectible Gravity",
	# MOB TIES
	KEYS.MOB_SPAWN_RATE_FACTOR: "Spawn Rate Factor",
	KEYS.MOB_COUNT_FACTOR: "Max Mob Factor"
}

var _state: Dictionary = {
	KEYS.PLAYER_CURRENCY: 300,
	KEYS.PLAYER_ROTATION_SPEED: 1.0,
	KEYS.PLAYER_MOVEMENT_FACTOR: 1.0,
	KEYS.PLAYER_PROJECTILE_FACTOR: 1.0,
	KEYS.PLAYER_ACCELERATION_FACTOR: 1.0,
	KEYS.PLAYER_DMG_FACTOR: 1.0,
	# WIP	
	KEYS.PLAYER_HP_FACTOR: 1.0, 
	KEYS.PLAYER_CRITICAL_HIT_FACTOR: 1.0,
	KEYS.PLAYER_PROJECTILE_PENETRATION: 1.0,
	KEYS.PLAYER_GRAVITY_SCALE: 1.0,
	# MOB TINGS
	KEYS.MOB_SPAWN_RATE_FACTOR: 1.0,
	KEYS.MOB_COUNT_FACTOR: 1.0,
	# AUTOPILOT
	KEYS.AUTOPILOT_ENABLED: false
}


func get_item(key: KEYS) -> Variant:
	return _state[key]


func set_item(key: KEYS, value: Variant) -> void:
	_state[key] = value
	state_changed.emit(key, value)


func key_to_text(key: KEYS) -> String:
	return ENUM_TO_TEXT[key] if ENUM_TO_TEXT.has(key) else ''
