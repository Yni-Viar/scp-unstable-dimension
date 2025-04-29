extends Node3D
class_name GameCore
## Game system.
## Made by Yni, licensed under MIT license.

const FACILITIES: PackedStringArray = ["res://MapGen/EvacuationShelter.tres", "res://MapGen/MaintenanceTunnels.tres"]


@export var gamedata: GameData
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var player: Node3D
## It is actually how many generators are left
var activated_generators: int = 0
## Presets for game ##
var map_seed: int = -1
var all_generators: int = -1
var enemy_type: int = -1
var chaos_amount: int = -1
var spawn_neutral_npcs: int = -1
var additional_lives: int = -1
var choosed_map: int = -1
var time_amount: float = 120.0
## End presets for game ##

## Enemy spawn check
var enemy_spawned: bool = false
## Additional lives amount
var lives: Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameOverTimer.start(time_amount)
	# Choose map
	if choosed_map >= 0:
		$FacilityGenerator.rooms[0] = load(FACILITIES[choosed_map])
	else:
		$FacilityGenerator.rooms[0] = load(FACILITIES[rng.randi_range(0, FACILITIES.size() - 1)])
	# Choose seed
	if map_seed >= 0:
		$FacilityGenerator.rng_seed = map_seed
	$FacilityGenerator.generate_rooms()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !$GameOverTimer.is_stopped():
		$UI/Tasks/TimeToLeft.text = tr("SECOND_LEFT") + str(ceili($GameOverTimer.time_left))
		$UI/Tasks/GeneratorsToActivate.text = tr("GENERATOR_LEFT") + str(activated_generators)
		if ceili($GameOverTimer.time_left) == 110 && !enemy_spawned && enemy_type != 0:
			spawn_enemies()
			enemy_spawned = true


func _on_facility_generator_generated() -> void:
	spawn_puppets()

func spawn_puppets():
	# Player and allies
	var protagonist: MovableNpc = load("res://PlayerScript/NPCBase.tscn").instantiate()
	protagonist.puppet_class = gamedata.puppet_class[0]
	var spawns = get_tree().get_nodes_in_group("ScientistSpawn")
	var selected_spawn: Marker3D = spawns[rng.randi_range(0, spawns.size() - 1)]
	selected_spawn.add_child(protagonist)
	$StaticPlayer.target_puppet_path = protagonist.get_path()
	for i in range(2 if additional_lives < 0 else additional_lives):
		if i < selected_spawn.get_child_count() - 1:
			var friendly_puppet: MovableNpc = load("res://PlayerScript/NPCBase.tscn").instantiate()
			friendly_puppet.puppet_class = gamedata.friend_puppet_class[rng.randi_range(0, gamedata.friend_puppet_class.size() - 1)]
			selected_spawn.get_child(i).add_child(friendly_puppet)
			friendly_puppet.follow_target = protagonist.get_path()
			lives.append(friendly_puppet)
	lives.append(protagonist)
	# Generators
	var gen_spawns = get_tree().get_nodes_in_group("GeneratorSpawn")
	for j in range(rng.randi_range(2, 4) if all_generators < 0 else all_generators):
		if j < gen_spawns.size():
			var generator: Node3D = load("res://Assets/ExternalModels/power_box.tscn").instantiate()
			gen_spawns[j].add_child(generator)
			activated_generators += 1
	all_generators = activated_generators
	# Neutral puppets
	if gamedata.neutral_puppet_class.size() > 0:
		var neutral_puppet_rand: int = rng.randi_range(-1, gamedata.neutral_puppet_class.size() - 1) if spawn_neutral_npcs < 0 else rng.randi_range(0, gamedata.neutral_puppet_class.size() - 1)
		if neutral_puppet_rand != -1:
			var npc: MovableNpc = load("res://PlayerScript/NPCBase.tscn").instantiate()
			npc.puppet_class = gamedata.neutral_puppet_class[neutral_puppet_rand]
			get_tree().get_first_node_in_group("NeutralEntitySpawn").add_child(npc)

## Enemy spawner
func spawn_enemies():
	if gamedata.enemy_puppet_class.size() > 0 && get_tree().get_node_count_in_group("EnemySpawn") > 0:
		spawn_enemy_entity()

## Spawns enemy entities
func spawn_enemy_entity():
	var enemy_type: int = rng.randi_range(0, 1) if enemy_type < 0 else enemy_type - 1
	var how_much_spawn: int = -1
	match enemy_type:
		0: # Chaos Insurgency
			how_much_spawn = rng.randi_range(2, 3) if chaos_amount < 0 else chaos_amount
		1: # SCP-266
			how_much_spawn = 1
	var spawn = get_tree().get_first_node_in_group("EnemySpawn")
	for i in range(how_much_spawn):
		var vfxspawn = load("res://Assets/VFX/enemyspawnvfx.tscn").instantiate()
		spawn.get_child(i).add_child(vfxspawn)
	await get_tree().create_timer(1.0).timeout
	for i in range(how_much_spawn):
		var enemy: MovableNpc = load("res://PlayerScript/NPCBase.tscn").instantiate()
		match enemy_type:
			0: # Chaos Insurgency
				# Second chaos isurgent is always hacker, others are troopers
				enemy.puppet_class = gamedata.enemy_puppet_class[0 if i != 1 else 1]
			1: # SCP-266
				enemy.puppet_class = gamedata.enemy_puppet_class[2]
		#enemy.puppet_class = gamedata.enemy_puppet_class[class_id]
		spawn.get_child(i).add_child(enemy)
	for i in range(how_much_spawn):
		for node in spawn.get_child(i).get_children():
			if node is not MovableNpc:
				node.queue_free()

## Game end
func finish_game(good_end: bool, reason: String):
	$UI/Condition/ConditionLabel.text = "GAME_WIN" if good_end else "GAME_OVER"
	$UI/Condition.show()
	$UI/Condition/ReasonLabel.text = reason
	$GameOverTimer.stop()
	Settings.set_pause_subtree(true)


func _on_game_over_timer_timeout() -> void:
	finish_game(false, "GAME_OVER_2")
