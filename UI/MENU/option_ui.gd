extends Control

func _on_h_slider_drag_ended(_value_changed: bool) -> void:
	global_script.sensivity = $HSlider.value


func _on_move_input_pressed() -> void:
	if global_script.move == "zqsd":
		global_script.move = "wasd"
	else:
		global_script.move = "zqsd"

func _on_button_return_pressed() -> void:
	get_parent().accueil()
