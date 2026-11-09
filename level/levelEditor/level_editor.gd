extends Node3D

var loadbloc = preload("res://level/levelEditor/props/blocs/editBloc.tscn")
var boost = preload("res://level/levelEditor/props/blocs/editBoost.tscn")
var finish = preload("res://level/levelEditor/props/blocs/edit_finish.tscn")
var wall = preload("res://level/levelEditor/props/blocs/editWall.tscn")
var ramp = preload("res://level/levelEditor/props/blocs/edit_ramp.tscn")
var bump = preload("res://level/levelEditor/props/blocs/edit_bump.tscn")
var magnet = preload("res://surface/magnet/edit_magnet.tscn")

var medals : String = "13,5,3"

func _ready() -> void:
	if global_script.import != "":
		for n in $blocContainer.get_children():
			$blocContainer.remove_child(n)
			var file = FileAccess.open(str("res://save/level/" + global_script.import), FileAccess.READ).get_as_text()
			file = file.split("/")
			medals = file[0]
			print(medals)
			file.remove_at(0)
			for bloc in file:
				var info = bloc.split(":")
				var pos = info[1].split(",")
				var rota = float(info[2])
				place(info[0], Vector3(float(pos[0]), float(pos[1]), float(pos[2])), float(rota))
		$CanvasLayer/LineLevelName.visible = false

func place(blocName : String, pos : Vector3, rota : float):
	if blocName == "bloc":
		var child = loadbloc.instantiate()
		$blocContainer.add_child(child)
		child.global_position = pos
		child.global_rotation.y = deg_to_rad(rota)
		child.blocName = blocName
		$creaChar.edit_target = child
	if blocName == "boost":
		var child = boost.instantiate()
		$blocContainer.add_child(child)
		child.global_position = pos
		child.global_rotation.y = deg_to_rad(rota)
		child.blocName = blocName
		$creaChar.edit_target = child
	if blocName == "wall":
		var child = wall.instantiate()
		$blocContainer.add_child(child)
		child.global_position = pos
		child.global_rotation.y = deg_to_rad(rota)
		child.blocName = blocName
		$creaChar.edit_target = child
	if blocName == "ramp":
		var child = ramp.instantiate()
		$blocContainer.add_child(child)
		child.global_position = pos
		child.global_rotation.y = deg_to_rad(rota)
		child.blocName = blocName
		$creaChar.edit_target = child
	if blocName == "bump":
		var child = bump.instantiate()
		$blocContainer.add_child(child)
		child.global_position = pos
		child.global_rotation.y = deg_to_rad(rota)
		child.blocName = blocName
		$creaChar.edit_target = child
	if blocName == "finish":
		var child = finish.instantiate()
		$blocContainer.add_child(child)
		child.blocName = blocName
		child.global_position = pos
	if blocName == "magnet":
		var child = magnet.instantiate()
		$blocContainer.add_child(child)
		child.global_position = pos
		child.global_rotation.y = deg_to_rad(rota)
		child.blocName = blocName
		$creaChar.edit_target = child

func _on_button_save_pressed() -> void:
	if global_script.import == "":
		if $CanvasLayer/LineLevelName.text != null:
			var fileText = medals
			for bloc in $blocContainer.get_children():
				fileText += "/" + str(bloc.blocName) + ":" + str(bloc.global_position.x) + "," + str(bloc.global_position.y) + "," + str(bloc.global_position.z)
				fileText += ":" + str(rad_to_deg(bloc.global_rotation.y))
			if $CanvasLayer/LineLevelName.text == "":
				FileAccess.open(str("res://save/level/" + "untitle"), FileAccess.WRITE).store_string(fileText)
				FileAccess.open(str("res://save/time/" + "untitle"), FileAccess.WRITE).store_string("-1")
				var r = FileAccess.open(str("res://save/level/pre/levels"), FileAccess.READ).get_as_text() + "/untitle"
				var w = FileAccess.open(str("res://save/level/pre/levels"), FileAccess.WRITE)
				w.store_string(r)
			else:
				FileAccess.open(str("res://save/level/" + $CanvasLayer/LineLevelName.text), FileAccess.WRITE).store_string(fileText)
				FileAccess.open(str("res://save/time/" + $CanvasLayer/LineLevelName.text), FileAccess.WRITE).store_string("-1")
				var r = FileAccess.open(str("res://save/level/pre/levels"), FileAccess.READ).get_as_text() + "/" + $CanvasLayer/LineLevelName.text
				var w = FileAccess.open(str("res://save/level/pre/levels"), FileAccess.WRITE)
				w.store_string(r)
			get_tree().change_scene_to_file("res://UI/MENU/mainPage.tscn")
	else:
		var fileText = medals
		for bloc in $blocContainer.get_children():
			fileText += "/" + str(bloc.blocName) + ":" + str(bloc.global_position.x) + "," + str(bloc.global_position.y) + "," + str(bloc.global_position.z)
			fileText += ":" + str(rad_to_deg(bloc.global_rotation.y))
		FileAccess.open(str("res://save/level/" + global_script.import), FileAccess.WRITE).store_string(fileText)
		FileAccess.open(str("res://save/" + global_script.import), FileAccess.WRITE).store_string("-1")
		get_tree().change_scene_to_file("res://UI/MENU/mainPage.tscn")

func _on_button_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/MENU/mainPage.tscn")


func _on_button_save_medal_pressed() -> void:
	medals = str($CanvasLayer/CanvasLayer/LineSilver.text) + "," + str($CanvasLayer/CanvasLayer/LineGold.text) + "," + str($CanvasLayer/CanvasLayer/LineDiamond.text)
	$CanvasLayer/CanvasLayer.visible = false

func _on_button_set_medals_pressed() -> void:
	$CanvasLayer/CanvasLayer.visible = true
