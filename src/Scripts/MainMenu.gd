extends Control


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
	var game: Node = load("res://Scenes/Game.tscn").instantiate()
	get_tree().root.add_child(game)
	get_tree().current_scene = game
	get_tree().root.get_node("Menu").queue_free()


func _on_credits_pressed() -> void:
	$CreditsContainer.visible = $Credits.button_pressed


func _on_lore_pressed() -> void:
	$LorePanel.show()


func _on_lore_back_button_pressed() -> void:
	$LorePanel.hide()
