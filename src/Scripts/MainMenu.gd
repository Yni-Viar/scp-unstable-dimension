extends Control
## Main Menu
## Made by Yni, licensed under MIT license.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the region (needed for obeying contries' laws)
	Settings.region = OS.get_locale()
	Settings.touchscreen = DisplayServer.is_touchscreen_available()
	var index: int = 0
	for node in $LorePanel/ScrollContainer/VBoxContainer.get_children():
		# Easy bit-field checking
		node.visible = (Settings.setting_res.secrets >> index) % 2 == 1
		index += 1
	
	# Display game ratings in main menu in some countries, this will replace the game logo.
	if Settings.legal_req:
		match Settings.region:
			"ru_RU":
				# New upcoming Russian law.
				$LawRegulation.texture = load("res://UI/MainMenu/LawRegulation/RU.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	play()


func _on_credits_pressed() -> void:
	$CreditsContainer.visible = $Credits.button_pressed


func _on_lore_pressed() -> void:
	$LorePanel.show()


func _on_lore_back_button_pressed() -> void:
	$LorePanel.hide()

func play(mapgen_seed: int = -1, enemy_type: int = -1, generator_amount: int = -1, chaos_amount: int = -1, spawn_neutral_npc: int = -1, additional_lives: int = -1, facility_id: int = -1, time_left: float = 120.0):
	var game: GameCore = load("res://Scenes/Game.tscn").instantiate()
	if mapgen_seed >= 0:
		game.map_seed = mapgen_seed
	if generator_amount >= 0:
		game.all_generators = generator_amount
	if enemy_type >= 0:
		game.enemy_type = enemy_type
	if spawn_neutral_npc >= 0:
		game.spawn_neutral_npcs = spawn_neutral_npc
	if chaos_amount >= 0:
		game.chaos_amount = chaos_amount
	if additional_lives >= 0:
		game.additional_lives = additional_lives
	if facility_id >= 0:
		game.choosed_map = facility_id
	game.time_amount = time_left
	get_tree().root.add_child(game)
	get_tree().current_scene = game
	get_tree().root.get_node("Menu").queue_free()


func _on_custom_play_pressed() -> void:
	$CustomGamePanel.show()


func _on_customplay_back_button_pressed() -> void:
	$CustomGamePanel.hide()
