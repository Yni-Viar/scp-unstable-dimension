extends Node3D
class_name GeneratorSystem

enum ActivatedStatus {UNACTIVATED, ACTIVATING, ACTIVATED}
var activated: ActivatedStatus = ActivatedStatus.UNACTIVATED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Display.text = "UNINITIALIZED"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if activated == ActivatedStatus.ACTIVATING:
		if !$Timer.is_stopped():
			$Display.text = "ACTIVATING...\n" + str(ceili($Timer.time_left)) + "\nSECONDS LEFT"


func _on_puppet_awaiter_body_entered(body: Node3D) -> void:
	if body is MovableNpc:
		if body.fraction == 0:
			if activated == ActivatedStatus.UNACTIVATED && body.get_node("PlayerModel").get_child(0).get_node_or_null("Tracker") != null:
				$Timer.start()
				activated = ActivatedStatus.ACTIVATING
				body.get_node("PlayerModel").get_child(0).secondary_state = body.get_node("PlayerModel").get_child(0).SecondaryState.INTERACT
				await get_tree().create_timer(2.0).timeout
				body.get_node("PlayerModel").get_child(0).secondary_state = body.get_node("PlayerModel").get_child(0).SecondaryState.NONE
		elif body.fraction == 3:
			if body.puppet_class.puppet_class_name == "CHAOS_HACKER":
				if activated == ActivatedStatus.ACTIVATED:
					activated = ActivatedStatus.UNACTIVATED
					get_tree().root.get_node("Game").activated_generators += 1
					$Display.text = "ERROR!!!"
					body.get_node("PlayerModel").get_child(0).secondary_state = body.get_node("PlayerModel").get_child(0).SecondaryState.INTERACT
					await get_tree().create_timer(2.0).timeout
					body.get_node("PlayerModel").get_child(0).secondary_state = body.get_node("PlayerModel").get_child(0).SecondaryState.NONE
					body.get_node("PlayerModel").get_child(0).active_generator = false

func _on_timer_timeout() -> void:
	$Display.text = "ACTIVATED"
	activated = ActivatedStatus.ACTIVATED
	get_tree().root.get_node("Game").activated_generators -= 1
