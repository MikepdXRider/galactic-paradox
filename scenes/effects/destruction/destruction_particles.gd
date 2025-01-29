extends CPUParticles2D

@onready var timer: Timer = $Timer


func _ready() -> void:
	one_shot = true
	emitting = true
	timer.timeout.connect(queue_free)
	timer.start(lifetime)
