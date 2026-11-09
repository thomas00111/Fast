extends StaticBody3D

@export var rota : float

func relativePlace():
	return rota + rad_to_deg(get_parent().global_rotation.y)

func edit(dir : String, remove : bool):
	get_parent().edit(dir, remove)
