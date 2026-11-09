extends Control

var button = preload("res://UI/MENU/main_button.tscn")

func _ready() -> void:
	global_script.loadedGhost = null
	
	var r = FileAccess.open(str("res://save/level/pre/levels"), FileAccess.READ)
	var list = r.get_as_text().split("/")
	var compt = 150
	for level in list:
		var inButton = button.instantiate()
		add_child(inButton)
		if compt < 1500:
			inButton.position = Vector2(compt, 200)
		elif compt < 3000:
			inButton.position = Vector2(compt - 1500, 400)
		elif compt < 4500:
			inButton.position = Vector2(compt - 3000, 600)
		else:
			inButton.position = Vector2(compt - 4500, 800)
		inButton.text = level
		inButton.level = level
		compt += 200

func button_pressed(level : String):
	global_script.level = level
	get_tree().change_scene_to_file("res://level/levelEditor/level.tscn")


func _on_button_option_pressed() -> void:
	get_parent().option()


func _on_button_return_pressed() -> void:
	get_parent().accueil()


func _on_button_tuto_pressed() -> void:
	global_script.level = "tutorial"
	get_tree().change_scene_to_file("res://level/tuto.tscn")
