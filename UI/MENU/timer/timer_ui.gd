extends Node

var milisec = 0
var sec = 0
var minute = 0

func _ready() -> void:
	$timer_label.text = "00 : 00 . 0"
	$seconde.start()

func _on_seconde_timeout() -> void:
	milisec += 1
	if milisec >= 10:
		milisec = 0

		sec += 1
	if sec >= 60:
		sec = 0
		minute += 1
		if minute < 10:
			$timer_label.text = str("0", minute, " : 0", sec, " . ", milisec)
		else:
			$timer_label.text = str(minute, " : 0", sec, " . ", milisec)
	elif sec < 10:
		if minute < 10:
			$timer_label.text = str("0", minute, " : 0", sec, " . ", milisec)
		else:
			$timer_label.text = str(minute, " : 0", sec, " . ", milisec)
	else:
		if minute < 10:
			$timer_label.text = str("0", minute, " : ", sec, " . ", milisec)
		else:
			$timer_label.text = str(minute, " : ", sec, " . ", milisec)

func restart():
	$seconde.stop()
	milisec = 0
	sec = 0
	minute = 0
	$timer_label.text = "00 : 00 . 000"
	$seconde.start()

func end():
	$seconde.stop()
