extends Control

var exiting: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_seed_text_changed(new_text):
	#if new_text != "":
		#get_parent().get_node("FacilityGenerator").rng_seed = hash(new_text)
	#else:
		#get_parent().get_node("FacilityGenerator").rng_seed = -1
#
#
#func _on_generate_pressed():
	#get_parent().get_node("FacilityGenerator").clear()
	#get_parent().get_node("FacilityGenerator").prepare_generation()


func _on_back_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
	var menu: Node = load("res://Scenes/Menu.tscn").instantiate()
	get_tree().root.add_child(menu)
	get_tree().current_scene = menu
	get_tree().root.get_node("Game").queue_free()
