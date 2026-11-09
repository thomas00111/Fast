extends Node3D

func relativePlace():
	var pos = $CollisionShape3D.global_position
	if get_parent().name == "InviProp":
		return Vector3(pos.x, pos.y - 0.5, pos.z + 2.3)
	if get_parent().name == "InviProp2":
		return Vector3(pos.x - 2.3, pos.y - 0.5, pos.z)
	if get_parent().name == "InviProp3":
		return Vector3(pos.x, pos.y - 0.5, pos.z - 2.3)
	if get_parent().name == "InviProp4":
		return Vector3(pos.x + 2.3, pos.y - 0.5, pos.z)

func edit(dir : String, remove : bool):
	get_parent().get_parent().edit(dir, remove)
