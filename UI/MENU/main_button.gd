extends Button

var level : String

func _on_pressed() -> void:
	get_parent().button_pressed(level)
