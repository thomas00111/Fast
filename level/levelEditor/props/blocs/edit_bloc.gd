extends Node3D

var blocName : String = "bloc"

func edit(dir : String, remove : bool):
	if dir == "up":
		global_position.y += 1
	if dir == "down":
		global_position.y -= 1
	
	if dir == "forward":
		global_position.z += 1
	if dir == "backward":
		global_position.z -= 1
	if dir == "left":
		global_position.x += 1
	if dir == "right":
		global_position.x -= 1
	if dir == "rotaLeft":
		rotation.y += deg_to_rad(90)
	if dir == "rotaRight":
		rotation.y -= deg_to_rad(90)
	
	if remove:
		self.queue_free()
