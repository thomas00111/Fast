extends Node3D

var loadbloc = preload("res://props/block/bloc.tscn")
var boost = preload("res://surface/boost/boost.tscn")
var wall = preload("res://props/block/wall.tscn")
var ramp = preload("res://props/ramp/ramp.tscn")
var bump = preload("res://props/bump/bump.tscn")
var finishBloc = preload("res://finish/finish.tscn")
var magnet = preload("res://surface/magnet/magnet.tscn")

var nb_dash_start = 2

var move : bool = true
var jump : bool = false
var dash : bool = false
var grappin : bool = false
var wallJump : bool = false

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
	var file = FileAccess.open(str("res://save/level/pre/tutorial"), FileAccess.READ).get_as_text()
	file = file.split("/")
	file.remove_at(0)
	for bloc in file:
		var info = bloc.split(":")
		var pos = info[1].split(",")
		var rota = info[2]
		place(String(info[0]), Vector3(float(pos[0]), float(pos[1]), float(pos[2])), float(rota))

func finish(nb_dash, grappin, ghost_list):
	$tuto_finish.contentTuto(($timer_ui.sec + $timer_ui.minute * 60)*10 + $timer_ui.milisec, nb_dash_start == nb_dash, grappin, ghost_list)
	$timer_ui.queue_free()
	$Character.can_pause = false
	$Character.hide_ui()
	$Character.movement_enable = false
	$tuto_finish.visible = true



func _process(delta: float) -> void:
	if $Character.global_position.z >= -8.67:
		if !move:
			$Jump.visible = false
			$LabelJump.visible = false
			$Dash.visible = false 
			$Grappin.visible = false
			$Wall.visible = false
			$Move.visible = true
			$zqsd.visible = true
			move = true
			jump = false
			dash = false
			grappin = false
			wallJump = false
	elif $Character.global_position.z >= -22.83491:
		if !jump:
			$Jump.visible = true
			$LabelJump.visible = true
			$Dash.visible = false 
			$Grappin.visible = false
			$Wall.visible = false
			$Move.visible = false
			$zqsd.visible = false
			move = false
			jump = true
			dash = false
			grappin = false
			wallJump = false
	elif $Character.global_position.z >= -48.18748:
		if !dash:
			$Jump.visible = false
			$LabelJump.visible = false
			$Dash.visible = true
			$Grappin.visible = false
			$Wall.visible = false
			$Move.visible = false
			$zqsd.visible = false
			move = false
			jump = false
			dash = true
			grappin = false
			wallJump = false
	elif $Character.global_position.z >= -72.73978:
		if !grappin:
			$Jump.visible = false
			$LabelJump.visible = false
			$Dash.visible = false
			$Grappin.visible = true
			$Wall.visible = false
			$Move.visible = false
			$zqsd.visible = false
			move = false
			jump = false
			dash = false
			grappin = true
			wallJump = false
	elif $Character.global_position.z >= -108.5555:
		if !wallJump:
			$Jump.visible = false
			$LabelJump.visible = false
			$Dash.visible = false
			$Grappin.visible = false
			$Wall.visible = true
			$Move.visible = false
			$zqsd.visible = false
			move = false
			jump = false
			dash = false
			grappin = false
			wallJump = true
	else:
		$Jump.visible = false
		$LabelJump.visible = false
		$Dash.visible = false
		$Grappin.visible = false
		$Wall.visible = false
		$Move.visible = false
		$zqsd.visible = false
		move = false
		jump = false
		dash = false
		grappin = false
		wallJump = false
