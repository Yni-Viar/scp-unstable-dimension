extends HumanPuppetScript


var active_generator: bool = false:
	set(val):
		if !val && !get_parent().get_parent().wandering:
			set_physics_process(false)
			await get_tree().create_timer(10.0).timeout
			set_physics_process(true)
		active_generator = val

# Called when the node enters the scene tree for the first time.
#func on_start_human() -> void:
	# Retrieve protagonist node path and make it follow target
	#get_parent().get_parent().follow_target = get_tree().get_first_node_in_group("MainCharacter").get_parent().get_parent().get_parent().get_path()


func on_update_human(delta: float):
	if !active_generator:
		check_generator()

func check_generator():
	if get_tree().root.get_node("Game").activated_generators < get_tree().root.get_node("Game").all_generators:
		for node in get_tree().get_nodes_in_group("GeneratorSpawn"):
			if node.get_child_count() > 0:
				if node.get_child(0) is GeneratorSystem:
					if node.get_child(0).activated == node.get_child(0).ActivatedStatus.ACTIVATED:
						get_parent().get_parent().wandering = false
						get_parent().get_parent().follow_target = node.get_path()
						active_generator = true
