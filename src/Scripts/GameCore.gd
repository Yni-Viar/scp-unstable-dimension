extends Node3D

@export var gamedata: GameData
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var player: Node3D
## It is actually how many generators are left
var activated_generators: int = 0
## How many generators are spawned
var all_generators: int
var enemy_spawned: bool = false
var lives: Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FacilityGenerator.prepare_generation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !$GameOverTimer.is_stopped():
		$UI/TimeToLeft.text = "SECONDS LEFT: " + str(ceili($GameOverTimer.time_left))
		if ceili($GameOverTimer.time_left) == 110 && !enemy_spawned:
			spawn_enemies()
			enemy_spawned = true


func _on_facility_generator_generated() -> void:
	#if player == null:
		#player = load("res://PlayerScript/static_player.tscn").instantiate()
		#add_child(player)
	#player.global_position = Vector3(($FacilityGenerator.zone_size * ($FacilityGenerator.map_size_x + 1)) / 2 * $FacilityGenerator.grid_size, 0, ($FacilityGenerator.zone_size * ($FacilityGenerator.map_size_y + 1)) / 2 * $FacilityGenerator.grid_size)
	spawn_puppets()

func spawn_puppets():
	# Player and allies
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
			lives.append(friendly_puppet)
	lives.append(protagonist)
	# Generators
	var gen_spawns = get_tree().get_nodes_in_group("GeneratorSpawn")
	for j in range(rng.randi_range(2, 4)):
		if j < gen_spawns.size():
			var generator: Node3D = load("res://Assets/ExternalModels/power_box.tscn").instantiate()
			gen_spawns[j].add_child(generator)
			activated_generators += 1
	all_generators = activated_generators

func spawn_enemies():
	if gamedata.enemy_puppet_class.size() > 0:
		spawn_enemy_entity(rng.randi_range(2, 3))#, rng.randi_range(0, gamedata.enemy_puppet_class.size() - 1))

func spawn_enemy_entity(how_much_spawn: int):
	var spawn = get_tree().get_first_node_in_group("EnemySpawn")
	for i in range(how_much_spawn):
		var vfxspawn = load("res://Assets/VFX/enemyspawnvfx.tscn").instantiate()
		spawn.get_child(i).add_child(vfxspawn)
	await get_tree().create_timer(1.0).timeout
	for i in range(how_much_spawn):
		var enemy: MovableNpc = load("res://PlayerScript/NPCBase.tscn").instantiate()
		# Temporary workaround, since all enemies are chaos insurgency
		# Second chaos isurgent is always hacker, others are troopers
		enemy.puppet_class = gamedata.enemy_puppet_class[0 if i != 1 else 1]
		#enemy.puppet_class = gamedata.enemy_puppet_class[class_id]
		spawn.get_child(i).add_child(enemy)
	for i in range(how_much_spawn):
		for node in spawn.get_child(i).get_children():
			if node is not MovableNpc:
				node.queue_free()
	

func finish_game(good_end: bool):
	$UI/Condition/ConditionLabel.text = "YOU WIN" if good_end else "YOU LOSE"
	$UI/Condition.show()
	$GameOverTimer.stop()
	get_tree().paused = true


func _on_game_over_timer_timeout() -> void:
	finish_game(false)
