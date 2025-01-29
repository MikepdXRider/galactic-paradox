extends Control

@export var target_key: GameState.KEYS

@onready var spin_box: SpinBox = $HBoxContainer/SpinBox
@onready var label: Label = $HBoxContainer/Label

var last_value: float

func _ready() -> void:
	last_value = GameState.get_item(target_key)
	spin_box.value = last_value
	spin_box.min_value = last_value
	label.text = GameState.key_to_text(target_key)
	

func _on_spin_box_value_changed(value: float) -> void:
	var difference = roundi((last_value - value) * 100)
	GameState.set_item(
		GameState.KEYS.PLAYER_CURRENCY,
		GameState.get_item(GameState.KEYS.PLAYER_CURRENCY) + difference
	)
	GameState.set_item(target_key, value)
	last_value = value
	
	if GameState.get_item(GameState.KEYS.PLAYER_CURRENCY) <= 0:
		spin_box.editable = false
