extends Control

func _ready() -> void:
	if global_script.inlevel:
		level()

func _on_button_play_pressed() -> void:
	level()

func level():
	$main.visible = true
	$accueil.visible = false
	$optionUi.visible = false
	$editor.visible = false
	global_script.inlevel = true

func accueil():
	$main.visible = false
	$accueil.visible = true
	$optionUi.visible = false
	$editor.visible = false
	global_script.inlevel = false

func option():
	$main.visible = false
	$accueil.visible = false
	$optionUi.visible = true
	$editor.visible = false

func _on_button_editor_pressed() -> void:
	$main.visible = false
	$accueil.visible = false
	$optionUi.visible = false
	$editor.visible = true


func _on_button_new_pressed() -> void:
	global_script.import = ""
	get_tree().change_scene_to_file("res://level/levelEditor/level_editor.tscn")

func _on_button_import_pressed() -> void:
	$editor.visible = false
	$import.visible = true

func _on_buttonback_pressed() -> void:
	$accueil.visible = true
	$editor.visible = false
	$import.visible = false

func _on_button_import_confirm_pressed() -> void:
	global_script.import = $import/LineImport.text
	get_tree().change_scene_to_file("res://level/levelEditor/level_editor.tscn")


func _on_buttonback_i_pressed() -> void:
	$editor.visible = true
	$import.visible = false
