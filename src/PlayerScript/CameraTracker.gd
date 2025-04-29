extends Marker3D
## Camera tracker (tracks on protagonist)
## Made by Yni, licensed under MIT license.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	get_tree().root.get_node("Game/StaticPlayer").global_position = global_position + Vector3(0, 3, 0)
