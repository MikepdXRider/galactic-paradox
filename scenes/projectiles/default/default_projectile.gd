extends Area2D

@export var IMPACT_EFFECT: PackedScene

@export var speed: int = 50
@export var life_time_sec: float = 5
@export var base_damage: float = 1

@onready var life_timer: Timer = $LifeTimer


func _ready() -> void:
	life_timer.timeout.connect(queue_free)
	life_timer.start(life_time_sec)


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(base_damage)
		if IMPACT_EFFECT:
			body.add_child(IMPACT_EFFECT.instantiate())
		queue_free()
