extends BasePuppetScript
## SCP-266 puppet script
## Created by Yni, licensed under dual license: for SCP content - GPL 3, for non-SCP - MIT License
class_name Scp266PlayerScript

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var heat_targets: Array[Node3D] = []
var active_targets: Array[int] = []
var timer: float = 4.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	scp_262_heateater(delta)

func scp_262_heateater(delta: float):
	if timer > 0:
		timer -= delta
	else:
		if heat_targets.size() > 0:
			get_parent().get_parent().wandering = false
			for i in range(heat_targets.size()):
				if heat_targets[i] is MovableNpc:
					# Only humans will freeze
					if heat_targets[i].puppet_class.fraction == 0 || heat_targets[i].puppet_class.fraction == 3:
						if heat_targets[i].current_health[0] - 10 < 0:
							heat_targets[i].health_manage(-10)
							heat_targets.remove_at(i)
							return
						heat_targets[i].health_manage(-10)
			get_parent().get_parent().follow_target = heat_targets[0].get_path()
		timer = 2.5

func _on_warm_detector_body_entered(body: Node3D) -> void:
	if body is MovableNpc:
		if body.puppet_class.fraction == 0 || body.puppet_class.fraction == 3:
			heat_targets.append(body)


func _on_warm_detector_body_exited(body: Node3D) -> void:
	if body is MovableNpc:
		if heat_targets.has(body):
			heat_targets.erase(body)
