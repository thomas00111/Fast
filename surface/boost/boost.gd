extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("boost_surface"):
		body.boost_surface(true)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.has_method("boost_surface"):
		body.boost_surface(false)
