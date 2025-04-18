extends Node3D

enum ActivatedStatus {UNACTIVATED, ACTIVATING, ACTIVATED}
var activated: ActivatedStatus = ActivatedStatus.UNACTIVATED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Display.text = "UNINITIALIZED"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if activated == ActivatedStatus.ACTIVATING:
		if !$Timer.is_stopped():
			$Display.text = "ACTIVATING...\n" + str(ceil($Timer.time_left)) + "\nSECONDS LEFT"


func _on_puppet_awaiter_body_entered(body: Node3D) -> void:
	if body is MovableNpc:
		if body.fraction == 0:
			if activated == ActivatedStatus.UNACTIVATED:
				$Timer.start()
				activated = ActivatedStatus.ACTIVATING
	



func _on_timer_timeout() -> void:
	$Display.text = "ACTIVATED"
	activated = ActivatedStatus.ACTIVATED
	get_tree().root.get_node("Game").activated_generators -= 1
