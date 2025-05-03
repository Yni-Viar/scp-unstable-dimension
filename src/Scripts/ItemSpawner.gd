extends Marker3D

@export var item: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().root.get_node("Game").rng.randi_range(0, 2) == 2 && item != null:
		var doc: Node3D = item.instantiate()
		add_child(doc)
