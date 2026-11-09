extends CharacterBody3D

var mouseInput : Vector2 = Vector2(0,0)
var mouse_sensitivity : float = 0.05
var placableBloc : String = "bloc"
var pause = false
var edit_target = null

var editMode : String = "moveUp"

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Head/Camera.fov = lerp($Head/Camera.fov, 85.0, 0.3)

func _unhandled_input(event : InputEvent):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouseInput.x += event.relative.x
		mouseInput.y += event.relative.y
	
func _physics_process(_delta):
	var input_dir = Vector2.ZERO
	input_dir = Input.get_vector("q", "d", "z", "s")

	var direction = input_dir.rotated(-$Head.rotation.y)
	direction = Vector3(direction.x, 0, direction.y)
	velocity.x /= 1.1
	velocity.z /= 1.1
	velocity.x += (direction.x * 1.02)
	velocity.z += (direction.z * 1.02)

	pose_bloc()
	edit_bloc()
	handle_head_rotation()
	handle_jump()
	
	move_and_slide()

func handle_head_rotation():
	$Head.rotation_degrees.y -= mouseInput.x * mouse_sensitivity
	$Head.rotation_degrees.x -= mouseInput.y * mouse_sensitivity
	
	mouseInput = Vector2(0,0)
	$Head.rotation.x = clamp($Head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func handle_jump():
	velocity.y /= 1.1
	if Input.is_action_pressed("jump"):
		velocity.y += 1.5
		$Timer_jump.start()
	if Input.is_action_pressed("ground_pound"):
		velocity.y -= 1.5
		$Timer_jump.start()

func _on_timer_jump_timeout() -> void:
	if !Input.is_action_pressed("ground_pound") && !Input.is_action_pressed("jump"):
		velocity.y = 0
	else:
		$Timer_jump.start()

func pose_bloc():
	if Input.is_action_just_pressed("dash") && !pause:
		if $Head/RayCast3D.is_colliding():
			if editMode == "remove":
				if $Head/RayCast3D.get_collider().has_method("edit"):
					$Head/RayCast3D.get_collider().edit("null", true)
			else:
				var target = $Head/RayCast3D.get_collider()
				var point = 0
				var pos = $Head/RayCast3D.get_collision_point() 
				if target.has_method("relativePlace"):
					point = target.relativePlace()
					pos = target.global_position
				get_parent().place(placableBloc, pos, point)

func edit_bloc():
	if Input.is_action_just_pressed("grappin") && !pause:
		if $Head/RayCast3D.is_colliding():
			if $Head/RayCast3D.get_collider().has_method("edit"):
				edit_target = $Head/RayCast3D.get_collider()
	
	
	if Input.is_action_just_pressed("arrowUp") && edit_target != null:
		if editMode == "moveUp":
			edit_target.edit("up", false)
		if editMode == "move":
			edit_target.edit("forward", false)
		if editMode == "rotate":
			edit_target.edit("rotaUp", false)
	if Input.is_action_just_pressed("arrowDown") && edit_target != null:
		if editMode == "moveUp":
			edit_target.edit("down", false)
		if editMode == "move":
			edit_target.edit("backward", false)
		if editMode == "rotate":
			edit_target.edit("rotaDown", false)
	
	if Input.is_action_just_pressed("arrowLeft") && edit_target != null:
		if editMode == "move":
			edit_target.edit("left", false)
		if editMode == "rotate":
			edit_target.edit("rotaLeft", false)
	if Input.is_action_just_pressed("arrowRight") && edit_target != null:
		if editMode == "move":
			edit_target.edit("right", false)
		if editMode == "rotate":
			edit_target.edit("rotaRight", false)
	
	
	
	if Input.is_action_just_pressed("remove") && edit_target != null:
		edit_target.edit("null", true)

func _process(_delta):
#------------------------------------PAUSE-------------------------------------------
	if Input.is_action_just_pressed("ui_cancel"):
		match Input.mouse_mode:
			Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				$crosshair.visible = false
				#$CanvasLayerPause.visible = true
				pause = true
			Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				$crosshair.visible = true
				#$CanvasLayerPause.visible = false
				pause = false


func _on_option_button_item_selected(index: int) -> void:
	var list = ["bloc", "ramp", "bump", "boost", "wall", "magnet", "finish"]
	placableBloc = list[index]


func _on_option_button_mode_item_selected(index: int) -> void:
	var list = ["moveUp", "move", "rotate", "remove"]
	editMode = list[index]
