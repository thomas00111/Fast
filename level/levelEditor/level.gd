extends Node3D

var loadbloc = preload("res://props/block/bloc.tscn")
var boost = preload("res://surface/boost/boost.tscn")
var wall = preload("res://props/block/wall.tscn")
var ramp = preload("res://props/ramp/ramp.tscn")
var bump = preload("res://props/bump/bump.tscn")
var finishBloc = preload("res://finish/finish.tscn")
var magnet = preload("res://surface/magnet/magnet.tscn")

var levelName : String = ""
var medals = [15, 10, 5]
var nb_dash_start = 2

func place(blocName : String, pos : Vector3, rota : float):
	if blocName == "bloc":
		var child = loadbloc.instantiate()
		$blocContainer.add_child(child)
		child.global_position = pos
		child.global_rotation.y = deg_to_rad(rota)
	if blocName == "boost":
		var child = boost.instantiate()
		$blocContainer.add_child(child)
		child.global_position = pos
		child.global_rotation.y = deg_to_rad(rota)
	if blocName == "wall":
		var child = wall.instantiate()
		$blocContainer.add_child(child)
		child.global_position = pos
		child.global_rotation.y = deg_to_rad(rota)
	if blocName == "ramp":
		var child = ramp.instantiate()
		$blocContainer.add_child(child)
		child.global_position = pos
		child.global_rotation.y = deg_to_rad(rota)
	if blocName == "bump":
		var child = bump.instantiate()
		$blocContainer.add_child(child)
		child.global_position = pos
		child.global_rotation.y = deg_to_rad(rota)
	if blocName == "finish":
		var child = finishBloc.instantiate()
		$blocContainer.add_child(child)
		child.global_position = pos
		child.global_rotation.y = deg_to_rad(rota)
	if blocName == "magnet":
		var child = magnet.instantiate()
		$blocContainer.add_child(child)
		child.global_position = pos
		child.global_rotation.y = deg_to_rad(rota)

func _ready() -> void:
	levelName = global_script.level
	var file = FileAccess.open(str("res://save/level/" + levelName), FileAccess.READ).get_as_text()
	file = file.split("/")
	var medals_list = file[0].split(",")
	medals = [float(medals_list[0]), float(medals_list[1]), float(medals_list[2])]
	file.remove_at(0)
	for bloc in file:
		var info = bloc.split(":")
		var pos = info[1].split(",")
		var rota = info[2]
		place(String(info[0]), Vector3(float(pos[0]), float(pos[1]), float(pos[2])), float(rota))

func finish(nb_dash, grappin, ghost_list):
	$finish_UI.content(levelName, medals, ($timer_ui.sec + $timer_ui.minute * 60)*10 + $timer_ui.milisec, nb_dash_start == nb_dash, grappin, ghost_list)
	$timer_ui.queue_free()
	$Character.can_pause = false
	$Character.hide_ui()
	$Character.movement_enable = false
	$finish_UI.visible = true
