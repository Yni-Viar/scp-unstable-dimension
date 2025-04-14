extends Node3D

@export var classes: Array[String] = []
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var player: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_facility_generator_generated() -> void:
	if player == null:
		player = load("res://PlayerScript/static_player.tscn").instantiate()
		add_child(player)
	player.global_position = Vector3(($FacilityGenerator.zone_size * ($FacilityGenerator.map_size_x + 1)) / 2 * $FacilityGenerator.grid_size, 0, ($FacilityGenerator.zone_size * ($FacilityGenerator.map_size_y + 1)) / 2 * $FacilityGenerator.grid_size)
	spawn_puppets()

func spawn_puppets():
	for spawner in get_tree().get_nodes_in_group("Spawner"):
		if classes.size() == 0:
			return
		var puppet_class_path: String = classes[rng.randi_range(0, classes.size() - 1)]
		var npc: MovableNpc = load("res://PlayerScript/NPCBase.tscn").instantiate()
		npc.puppet_class = load(puppet_class_path)
		spawner.add_child(npc)
