extends Area2D

@export var base_value: float = 1

var _target: Node2D
var _speed: float

func _physics_process(delta: float) -> void:
	if _target and _speed:
		position += (_target.position - position).normalized() * _speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameState.set_item(
			GameState.KEYS.PLAYER_CURRENCY,
			GameState.get_item(GameState.KEYS.PLAYER_CURRENCY) + base_value
		)
		queue_free()


func set_target(target: Node2D, speed: float = 100) -> void:
		_speed = speed
		_target = target
