extends Node3D
## Created by Yni, licensed under dual license: for SCP content - GPL 3, for non-SCP - MIT License

## Add lore by selecting a bit.
func _on_collect_area_body_entered(body: Node3D) -> void:
	if body is MovableNpc:
		var puppet_class = body.puppet_class
		if puppet_class.fraction == 0:
			if body.get_node("PlayerModel").get_child(0).get_node_or_null("Tracker"):
				Settings.setting_res.secrets += 2 ** get_tree().root.get_node("Game").rng.randi_range(0, 2)
				Settings.save_resource(Settings.setting_res)
				queue_free()
