extends Node2D

@export var type: GameState.SPAWN_TYPES
@export var time_allowed_offscreen: float = 10.0

@onready var despawn_timer: Timer = $DespawnTimer
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	if !visible_on_screen_notifier_2d.is_on_screen():
		despawn_timer.start(time_allowed_offscreen)
		
	despawn_timer.timeout.connect(despawn)
	
	visible_on_screen_notifier_2d.screen_entered.connect(_on_screen_entered)
	visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited)
	

func _on_screen_entered() -> void:
	despawn_timer.stop()
	
	
func _on_screen_exited() -> void:
	despawn_timer.start(time_allowed_offscreen)
	

func despawn() -> void:
	if get_parent():
		get_parent().queue_free()
	else:
		queue_free()

func is_on_screen() -> bool:
	return visible_on_screen_notifier_2d.is_on_screen()
