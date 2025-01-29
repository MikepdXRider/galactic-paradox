extends RigidBody2D

const GOLD_FLAKE = preload("res://scenes/collectibles/GoldFlake.tscn")

@export var health: float = 3
@export var destruction_effect: PackedScene

@onready var drop_loot_position: Marker2D = $DropLootPosition
@onready var despawner: Node2D = $Despawner


func take_damage(dmg: float) -> void:
	health -= dmg
	if health <= 0:
		_on_destruction()


func _on_destruction() -> void:
	if (
		!GameState.get_item(GameState.KEYS.AUTOPILOT_ENABLED) or \
		(randi() % 5) > 1
	):
		var new_flake = GOLD_FLAKE.instantiate()
		new_flake.transform = drop_loot_position.global_transform
		get_tree().root.add_child(new_flake)
	if destruction_effect:
		var new_destruction_effect = destruction_effect.instantiate()
		new_destruction_effect.transform = drop_loot_position.global_transform
		get_tree().root.add_child(new_destruction_effect)
	queue_free()


func is_on_screen() -> bool:
	return despawner.is_on_screen()
