extends Node2D

@export var modulate_color: Color
@export var duration_sec: float

@onready var timer: Timer = $Timer


func _ready() -> void:
	_enable()
	timer.start(duration_sec)
	timer.timeout.connect(_disable)


func _enable() -> void:
	get_parent().modulate += modulate_color


func _disable() -> void: 
	get_parent().modulate -= modulate_color
	queue_free()
