extends Node3D

var target = null

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("character"):
		target = body


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("character"):
		target = null

func _process(delta: float) -> void:
	if !target == null:
		var direction = (target.global_position).direction_to(Vector3(global_position.x, global_position.y + 2.5, global_position.z))
		target.velocity += direction * (delta * 40)


func _on_timer_particle_timeout() -> void:
	$CPUParticles3D.emitting = true
