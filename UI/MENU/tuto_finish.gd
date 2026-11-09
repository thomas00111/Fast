extends Control

var ghost

func contentTuto(milisec, dashless, grappinless, ghost_list):
	ghost = ghost_list
	if dashless:
		$NoDash.visible = true
	if grappinless:
		$NoGrappin.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if global_script.set_pb("tutorial", milisec):
		$Control/Label_pb.visible = true
		
		var f = FileAccess.open(str("res://save/ghost/tutorial"), FileAccess.WRITE)
		f.store_string(str(ghost_list))
	else:
		$Control/Label_bestTime.visible = true
		var mili = global_script.get_pb("tutorial")
		var minute2 = (mili/10)/60
		mili = mili - (minute2*10*60)
		var sec2 = (mili/10)
		mili = mili - (sec2*10)
		mili = mili%10
		if minute2 < 10:
			if sec2 <10:
				$Control/Label_bestTime.text = "best time : " + str("0", minute2, " : 0", sec2, " . ", mili)
			else:
				$Control/Label_bestTime.text = "best time : " + str("0", minute2, " : ", sec2, " . ", mili)
		else:
			if sec2 < 10:
				$Control/Label_bestTime.text = "best time : " + str(minute2, " : 0", sec2, " . ", mili)
			else:
				$Control/Label_bestTime.text = "best time : " + str(minute2, " : ", sec2, " . ", mili)
		
	
	var minute = (milisec/10)/60
	milisec = milisec - (minute*10*60)
	var sec = (milisec/10)
	milisec = milisec - (sec*10)
	milisec = milisec%10
	if minute < 10:
		if sec <10:
			$Control/Label_time.text = str("0", minute, " : 0", sec, " . ", milisec)
		else:
			$Control/Label_time.text = str("0", minute, " : ", sec, " . ", milisec)
	else:
		if sec < 10:
			$Control/Label_time.text = str(minute, " : 0", sec, " . ", milisec)
		else:
			$Control/Label_time.text = str(minute, " : ", sec, " . ", milisec)

func _on_button_main_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/MENU/mainPage.tscn")


func _on_button_save_ghost_pressed() -> void:
	$Control.visible = false
	$CanvasLayer.visible = true
	$medals.visible = false
	$NoDash.visible = false
	$NoGrappin.visible = false


func _on_button_save_pressed() -> void:
	var f = FileAccess.open(str("res://save/ghost/" + $CanvasLayer/LineEditGhost.text), FileAccess.WRITE)
	f.store_string(str(ghost))
	$Control.visible = true
	$CanvasLayer.visible = false
	$medals.visible = true
	$NoDash.visible = true
	$NoGrappin.visible = true


func _on_button_cancel_pressed() -> void:
	$Control.visible = true
	$CanvasLayer.visible = false
	$medals.visible = true
	$NoDash.visible = true
	$NoGrappin.visible = true


func _on_button_restart_pressed() -> void:
	get_parent().get_tree().reload_current_scene()
