extends Node3D

@export var gamedata: GameData
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var player: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FacilityGenerator.prepare_generation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_facility_generator_generated() -> void:
	#if player == null:
		#player = load("res://PlayerScript/static_player.tscn").instantiate()
		#add_child(player)
	#player.global_position = Vector3(($FacilityGenerator.zone_size * ($FacilityGenerator.map_size_x + 1)) / 2 * $FacilityGenerator.grid_size, 0, ($FacilityGenerator.zone_size * ($FacilityGenerator.map_size_y + 1)) / 2 * $FacilityGenerator.grid_size)
	spawn_puppets()

func spawn_puppets():
	var protagonist: MovableNpc = load("res://PlayerScript/NPCBase.tscn").instantiate()
	protagonist.puppet_class = gamedata.puppet_class[0]
	var spawns = get_tree().get_nodes_in_group("ScientistSpawn")
	var selected_spawn: Marker3D = spawns[rng.randi_range(0, spawns.size() - 1)]
	selected_spawn.add_child(protagonist)
	$StaticPlayer.target_puppet_path = protagonist.get_path()
	for i in range(2):
		if i < selected_spawn.get_child_count() - 1:
			var friendly_puppet: MovableNpc = load("res://PlayerScript/NPCBase.tscn").instantiate()
			friendly_puppet.puppet_class = gamedata.friend_puppet_class[rng.randi_range(0, gamedata.friend_puppet_class.size() - 1)]
			selected_spawn.get_child(i).add_child(friendly_puppet)
			friendly_puppet.follow_target = protagonist.get_path()
