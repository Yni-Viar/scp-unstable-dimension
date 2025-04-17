extends StaticBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	$Label3D.text = "GENERATORS LEFT: " + str(get_tree().root.get_node("Game").activated_generators)


func _on_puppet_awaiter_body_entered(body: Node3D) -> void:
	if get_tree().root.get_node("Game").activated_generators <= 0:
		get_tree().root.get_node("Game").finish_game(true)
