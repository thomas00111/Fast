extends Node3D

var nb = 1
var vec3list
var maxLen

func _ready() -> void:
	if int(FileAccess.open(str("res://save/time/" + global_script.level), FileAccess.READ).get_as_text()) == -1 && global_script.loadedGhost == null:
		queue_free()
	else:
		$Timer.start()
		var f
		if global_script.loadedGhost == null:
			f = FileAccess.open(str("res://save/ghost/" + global_script.level), FileAccess.READ).get_as_text()
		else:
			f = FileAccess.open(str("res://save/ghost/" + global_script.loadedGhost), FileAccess.READ).get_as_text()
		vec3list = f.split("(")
		maxLen = len(vec3list)

func _on_timer_timeout() -> void:
	if nb < maxLen:
		global_position = strToVector3(vec3list[nb])
		nb += 1

func strToVector3(stri : String):
	stri = stri.replace("),", "")
	stri = stri.replace("[", "")
	stri = stri.replace("]", "")
	var vlist = stri.split(",")
	return Vector3(float(vlist[0]), float(vlist[1]), float(vlist[2]))
