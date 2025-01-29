extends CanvasLayer

signal closed

func _ready() -> void:
	handle_button_state()
	process_mode = ProcessMode.PROCESS_MODE_WHEN_PAUSED


func _process(delta: float) -> void:
	handle_button_state()


func enable_game_state_inputs() -> void:
	for node in get_tree().get_nodes_in_group('upgrade_input'):
		if !node.editable:
			node.editable = true


func disable_game_state_inputs() -> void:
	for node in get_tree().get_nodes_in_group('upgrade_input'):
		if node.editable:
			node.editable = false


func handle_button_state() -> void:
	if GameState.get_item(GameState.KEYS.PLAYER_CURRENCY) > 0:
		enable_game_state_inputs()
	else:
		disable_game_state_inputs()


# TODO: EW EW EW EW EW
func close() -> void:
	_close()


func _close() -> void:
	get_tree().paused = false
	hide()
	closed.emit()
	
