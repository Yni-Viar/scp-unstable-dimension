extends StaticBody3D
## Escape room.
## Made by Yni, licensed under MIT license.


func _on_puppet_awaiter_body_entered(body: Node3D) -> void:
	if get_tree().root.get_node("Game").activated_generators <= 0:
		get_tree().root.get_node("Game").finish_game(true, "GAME_WIN_1")
