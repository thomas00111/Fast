extends RigidBody3D

var player
var stuck = false
var linemesh = null

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !body.is_in_group("character") && !body.is_in_group("inChar") && !body.is_in_group("point"):
		player.can_grappin = false
		freeze = true
		stuck = true
		$Area3D.queue_free()

func _process(delta: float) -> void:
	if linemesh != null:
		await get_tree().physics_frame
		linemesh.queue_free()
	if Input.is_action_just_released("grappin") || Input.is_action_just_pressed("ui_cancel"):
		if stuck:
			player.recan_grappin()
			player.velocity = player.velocity * 1.2
		self.queue_free()
	else:
		if player != null:
			var target : Vector3 = Vector3(player.position.x, player.position.y + 1.3, player.position.z)
			line(position, target, Color.BLACK, 1)
	if stuck && player.is_in_group("character"):
		player.gotoGrappin(global_position, delta)

func line(pos1: Vector3, pos2: Vector3, color, persist_ms):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	linemesh = mesh_instance
	get_tree().get_root().add_child(mesh_instance)
