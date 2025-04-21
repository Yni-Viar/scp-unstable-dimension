extends Marker3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().root.get_node("Game").rng.randi_range(0, 2) == 2:
		var doc: Node3D = load("res://Assets/OriginalModels/doc.tscn").instantiate()
		add_child(doc)
