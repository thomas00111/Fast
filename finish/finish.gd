extends Node3D

var menu_principal = "res://UI/MENU/menu_principal.tscn"
var blocName = "finish"

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("character"):
		body.input_list.append(body.global_position)
		get_parent().get_parent().finish(body.nb_dash, body.grappinless, body.input_list)
		body.input_list = []
		body.no_movement = true
