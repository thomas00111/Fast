extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("bump_surface"):
		body.bump_surface()

func _on_timer_particle_timeout() -> void:
	$CPUParticles3D.emitting = true
