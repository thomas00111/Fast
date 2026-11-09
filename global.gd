extends Node

var sensivity = 0.05
var loadedGhost = null
var level : String = ""
var inlevel : bool = false
var import : String = ""
var move = "zqsd"

func set_pb(level_name, milisec):
	var r = FileAccess.open(str("res://save/time/" + level_name), FileAccess.READ)
	if float(r.get_as_text()) == -1 || float(r.get_as_text()) > milisec:
		var f = FileAccess.open(str("res://save/time/" + level_name), FileAccess.WRITE)
		f.store_string(str(milisec))
		return true
	return false

func get_pb(level_name):
	return int(FileAccess.open(str("res://save/time/" + level_name), FileAccess.READ).get_as_text())
