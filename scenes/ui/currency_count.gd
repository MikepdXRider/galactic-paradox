extends HBoxContainer

@export var override_process_mode: ProcessMode

@onready var label: Label = $Label

func _ready() -> void:
	if override_process_mode:
		process_mode = override_process_mode


func _process(delta: float) -> void:
	label.text = str(GameState.get_item(GameState.KEYS.PLAYER_CURRENCY))
