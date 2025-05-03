extends Node3D
## Created by Yni, licensed under dual license: for SCP content - GPL 3, for non-SCP - MIT License

func _on_collect_area_body_entered(body: Node3D) -> void:
	if body is MovableNpc:
		if body.fraction == 0:
			body.health_manage(20.0)
