extends StaticBody3D

func edit(dir : String, remove : bool):
	get_parent().get_parent().edit(dir, remove)
