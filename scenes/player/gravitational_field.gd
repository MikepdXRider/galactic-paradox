extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func update_scale(value: float) -> void:
	scale = Vector2(value, value)


func handle_overlapping_areas() -> void:
	for area in get_overlapping_areas():
		_on_area_entered(area)


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("set_target"):
		print(str("Gravitational Field Pulling: ", area.name))
		area.set_target(get_parent())
