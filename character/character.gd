extends CharacterBody3D

#------------------------------------VARIABLE-------------------------------------------
#----------speed------------
var current_speed : float = 0.0
var acceleration : float = 10.0

var air_speed : float  = 1.1
var normal_ground_speed : float  = 5
var boost_ground_speed : float = 20
var wall_speed : float = 1.1


var current_ground_speed : float = normal_ground_speed

var jump_velocity : float = 4.5
var gravity : float = 9.81
#----------friction------------

var air_friction : float = 1.005
var wall_friction : float = 1.01
var groud_friction : float = 1.15

#----------dash---------------
var dashing : bool = false
var nb_dash : int = 2
var dash_velocity : float = 8
var side_dash_velocity : float = 6
var can_side_dash : bool = true

#----------ground-pound---------------
var nb_ground_pound : int = 2
var groud_pound_velocity : float = 20

#----------reference---------------

@onready var HEADBOB_ANIMATION = $Head/JumpAnimation/HeadbobAnimation
@onready var JUMP_ANIMATION =  $Head/JumpAnimation

#----------FOV---------------
var currentFov : String = "base"
var fovSpeedLimit : int = 15

#----------autre---------------
var immobile : bool = false
var movement_enable : bool = true
var no_movement : bool = false

var was_on_floor : bool = true
var wall_run : String = "none"

var mouseInput : Vector2 = Vector2(0,0)

var can_pause = true

var onBoost : int = 0

#----------OPTIONS---------------
var mouse_sensitivity : float = 0.05
var view_bobbing : bool = true

var fovChange : bool = false
var baseFov : float = 85.0
var speedFov : float = 100.0

#----------CAPACITE---------------
var double_jump_active : bool = false
var can_double_jump : bool = false
var double_jump_velocity : float = 5

var grappin_point = preload("res://props/grappling/grappling.tscn")
var grappin_velocity : float = 0.3
var can_grappin : bool = true

var grappinless : bool = true


#------------------------------------CODE-------------------------------------------
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Head/Camera.fov = lerp($Head/Camera.fov, baseFov, 0.3)
	$Timer_ghost.start()
	nb_dash = get_parent().nb_dash_start
	
	mouse_sensitivity = global_script.sensivity

func _unhandled_input(event : InputEvent):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouseInput.x += event.relative.x
		mouseInput.y += event.relative.y

#------------------------------------Process-------------------------------------------
func _physics_process(delta):
	#------------------------------------affiche speed-------------------------------------------
	current_speed = Vector3.ZERO.distance_to(get_real_velocity())
	#var cv : Vector3 = get_real_velocity()
	#var vd : Array[float] = [
		#snappedf(cv.x, 0.001),
		#snappedf(cv.y, 0.001),
		#snappedf(cv.z, 0.001)]
	#var readable_velocity : String = "X: " + str(vd[0]) + " Y: " + str(vd[1]) + " Z: " + str(vd[2])
	$LabelSpeed.text = str(round(current_speed))
	
	#------------------------------------Handle movement-------------------------------------------
	var input_dir = Vector2.ZERO
	if !no_movement:
		handle_jumping()
		if movement_enable:
			if global_script.move == "zqsd":
				input_dir = Input.get_vector("q", "d", "z", "s")
			elif global_script.move == "wasd":
				input_dir = Input.get_vector("a", "d", "w", "s")
			dash()
			sideDash()
			set_wall_run()
			handle_head_rotation()
			ground_pound()
			
			grappin()
		
		handle_movement(input_dir)
		set_gravity(delta)
	if !restart_level():
		return
	was_on_floor = is_on_floor()
	
	if is_on_floor():
		can_double_jump = false

	#--------------view bobbing-----------
	if view_bobbing:
		headbob_animation(input_dir)
	
	#--------------view bobbing-----------
	if fovChange:
		if current_speed > fovSpeedLimit and currentFov == "base":
			$Head/Camera.fov = lerp($Head/Camera.fov, speedFov, 0.5)
			currentFov = "speed"
		elif current_speed < fovSpeedLimit and currentFov == "speed":
			$Head/Camera.fov = lerp($Head/Camera.fov, baseFov, 0.5)
			currentFov = "base"
	
	#------------------------------------Handle animation-------------------------------------------
	if !was_on_floor and is_on_floor():
		match randi() % 2: #TODO: Change this to detecting velocity direction
			0:
				JUMP_ANIMATION.play("land_left", 0.25)
			1:
				JUMP_ANIMATION.play("land_right", 0.25)
	
	if !no_movement:
		move_and_slide()

#------------------------------------GRAVITY-------------------------------------------
func set_gravity(delta):
	if not is_on_floor() and gravity:
		velocity.y -= gravity * delta
		
#------------------------------------DASH-------------------------------------------
func dash():
	if Input.is_action_just_pressed("dash") && nb_dash > 0:
		nb_dash -= 1
		if !is_on_floor():
			dashing = true
		var direction = global_position.direction_to($Head/MarkerDash.global_position)
		direction.y /= 1.5
		velocity += direction * dash_velocity
		$dash_timer.start()

	if dashing && (is_on_floor() || is_on_ceiling()):
		if is_on_floor():
			velocity.y += 5
		else:
			velocity.y -= 5
		var direction = global_position.direction_to($Head/MarkerDash.global_position)
		direction.y = 0
		velocity += direction * dash_velocity
		dashing = false

func _on_dash_timer_timeout() -> void:
	dashing = false

func sideDash():
	if Input.is_action_just_pressed("rightDash") && can_side_dash:
		var direction = global_position.direction_to($Head/MarkerRight.global_position)
		direction.y = 0
		velocity += direction * side_dash_velocity
		can_side_dash = false
		$side_dash_timer.start()
	if Input.is_action_just_pressed("leftDash") && can_side_dash:
		var direction = global_position.direction_to($Head/MarkerLeft.global_position)
		direction.y = 0
		velocity += direction * side_dash_velocity

		can_side_dash = false
		$side_dash_timer.start()

func _on_side_dash_timer_timeout() -> void:
	can_side_dash = true

#------------------------------------JUMP-------------------------------------------
func handle_jumping():
	#-----------------------Double-Jump---------------------------
	if Input.is_action_just_pressed("jump") and can_double_jump and wall_run == "none" and double_jump_active:
		JUMP_ANIMATION.play("jump", 0.25)
		velocity.y += double_jump_velocity
		can_double_jump = false
	#-----------------------Normal-Jump---------------------------
	if Input.is_action_pressed("jump") and is_on_floor():
		JUMP_ANIMATION.play("jump", 0.25)
		velocity.y += jump_velocity
		$double_jump_delay.start()
	#-----------------------Wall-Jump--------------------------------------
	elif Input.is_action_just_pressed("jump") and wall_run == "left":
		wall_run = "none"
		JUMP_ANIMATION.play("jump", 0.25)
		var direction = global_position.direction_to($Head/MarkerRight.global_position)
		velocity += direction * jump_velocity
		velocity.y += jump_velocity*1.5
		
		$double_jump_delay.start()
		
	elif Input.is_action_just_pressed("jump") and wall_run == "right":
		wall_run = "none"
		JUMP_ANIMATION.play("jump", 0.25)
		var direction = global_position.direction_to($Head/MarkerLeft.global_position)
		velocity += direction * jump_velocity
		velocity.y += jump_velocity*1.5
		
		$double_jump_delay.start()

func _on_double_jump_delay_timeout() -> void:
	can_double_jump = true

#------------------------------------MOVEMENT-------------------------------------------
func handle_movement(input_dir):
	var direction = input_dir.rotated(-$Head.rotation.y)
	direction = Vector3(direction.x, 0, direction.y)

	if is_on_floor():
		velocity.x /= groud_friction
		velocity.z /= groud_friction
		if current_speed > 2:
			velocity.x += (direction.x * current_ground_speed)/(current_speed + 1)
			velocity.z += (direction.z * current_ground_speed)/(current_speed + 1)
		else:
			velocity.x += (direction.x * current_ground_speed)
			velocity.z += (direction.z * current_ground_speed)
	else :
		velocity.x /= air_friction
		velocity.z /= air_friction
		if current_speed > 1:
			velocity.x += (direction.x * air_speed)/current_speed
			velocity.z += (direction.z * air_speed)/current_speed

#------------------------------------ROTATION-------------------------------------------
func handle_head_rotation():
	$Head.rotation_degrees.y -= mouseInput.x * mouse_sensitivity
	$Head.rotation_degrees.x -= mouseInput.y * mouse_sensitivity
	
	mouseInput = Vector2(0,0)
	$Head.rotation.x = clamp($Head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

#------------------------------------GROUND-POUND-------------------------------------------
func ground_pound():
	if Input.is_action_just_pressed("ground_pound") && nb_ground_pound > 0:
		if !is_on_floor():
			nb_ground_pound -= 1
			if velocity.y > 0:
				velocity.y = 0
			velocity.y += - groud_pound_velocity

#------------------------------------WALL-RUN-------------------------------------------
func set_wall_run():
	if $Head/RayCastLeft.is_colliding():
		gravity = 0
		velocity.x /= wall_friction
		velocity.z /= wall_friction
		if wall_run != "left":
			wall_run = "left"
			velocity *= wall_speed
		if current_speed < 2:
			gravity = 1
			
		if velocity.y > 1:
			velocity.y -= 1
		if velocity.y < -2:
			velocity.y += 2
	else:
		if $Head/RayCastRight.is_colliding():
			gravity = 0
			if wall_run != "right":
				wall_run = "right"
				velocity *= wall_speed
			if current_speed < 2:
				gravity = 1
			if velocity.y > 1:
				velocity.y -= 1
			if velocity.y < -2:
				velocity.y += 2
		else:
			wall_run = "none"
			gravity = 9.81

#------------------------------------ANIMATION-------------------------------------------
func headbob_animation(moving):
	if moving and is_on_floor():
		var use_headbob_animation : String
		use_headbob_animation = "walk"
		var was_playing : bool = false
		if HEADBOB_ANIMATION.current_animation == use_headbob_animation:
			was_playing = true
		HEADBOB_ANIMATION.play(use_headbob_animation, 0.25)
		HEADBOB_ANIMATION.speed_scale = 1.75
		if !was_playing:
			HEADBOB_ANIMATION.seek(float(randi() % 2))
	else:
		if HEADBOB_ANIMATION.current_animation == "sprint" or HEADBOB_ANIMATION.current_animation == "walk":
			HEADBOB_ANIMATION.speed_scale = 1
			HEADBOB_ANIMATION.play("RESET", 1)

#------------------------------------GRAPPIN-------------------------------------------
func grappin():
	if Input.is_action_just_pressed("grappin") && can_grappin:
		grappinless = false
		var point = grappin_point.instantiate()
		get_parent().add_child(point)
		point.global_position = $Head/MarkerGrappin.global_position
		point.apply_force($Head/MarkerGrappin.global_position.direction_to($Head/MarkerDash.global_position) * 2000)
		point.player = self

func gotoGrappin(pos : Vector3, delta):
	var direction = global_position.direction_to(pos)
	velocity += direction * grappin_velocity * (delta * 60)

func recan_grappin():
	$timer_grappin.start()

func _on_timer_grappin_timeout() -> void:
	can_grappin = true

#------------------------------------SURFACE-------------------------------------------

func boost_surface(on : bool):
	if on:
		onBoost += 1
	else:
		onBoost -= 1
	if onBoost == 0:
		current_ground_speed = normal_ground_speed
	else:
		current_ground_speed = boost_ground_speed

func bump_surface():
	if velocity.y > 0:
		velocity.y += 15
	if velocity.y <= 0:
		velocity.y = 15

#------------------------------------UTILITE-------------------------------------------

func restart_level():
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		return false
	return true

func restart():
	get_tree().reload_current_scene()

func hide_ui():
	$crosshair.visible = false
	$LabelSpeed.visible = false
	$CanvasLayerPause.visible = false
	$CanvasLayerLoad.visible = false

func _process(_delta):
#------------------------------------PAUSE-------------------------------------------
	if Input.is_action_just_pressed("ui_cancel") && can_pause:
		match Input.mouse_mode:
			Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				$crosshair.visible = false
				$LabelSpeed.visible = false
				$CanvasLayerPause.visible = true
			Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				$crosshair.visible = true
				$LabelSpeed.visible = true
				$CanvasLayerPause.visible = false
				$CanvasLayerLoad.visible = false

func _on_button_main_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/MENU/mainPage.tscn")

func _on_button_load_ghost_pressed() -> void:
	$CanvasLayerPause.visible = false
	$CanvasLayerLoad.visible = true

func _on_button_load_pressed() -> void:
	if FileAccess.open(str("res://save/ghost/" + $CanvasLayerLoad/LineEditGhost.text), FileAccess.READ):
		global_script.loadedGhost = $CanvasLayerLoad/LineEditGhost.text
	$CanvasLayerPause.visible = false
	$CanvasLayerLoad.visible = false
	get_tree().reload_current_scene()

func _on_button_clear_ghost_pressed() -> void:
	global_script.loadedGhost = null
	$CanvasLayerPause.visible = false
	$CanvasLayerLoad.visible = false
	get_tree().reload_current_scene()

#------------------------------------GHOST-------------------------------------------
var input_list = []
func _on_timer_test_timeout() -> void:
	input_list.append(global_position)
