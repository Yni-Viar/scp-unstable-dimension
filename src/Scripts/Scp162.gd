extends Node3D
## SCP-162
## Created by Yni, licensed under dual license: for SCP content - GPL 3, for non-SCP - MIT License

## Targets. Keys are NPC, values - are NPC hypnotized
var targets: Array[MovableNpc] = []
## Safe value. If human is passing by, don't use it's hypnosis, if walked too fast.
var hold_on: bool = false
## Health deplete timer
var amount: float = 0.0
## Safe value. If human is passing by, don't use it's hypnosis, if walked too fast.
var hold_on_amount: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if hold_on:
		hold_on_amount += delta
		if hold_on_amount > 0.75:
			activate()
			hold_on_amount = 0.0
			hold_on = false
	amount += delta
	if amount > 2.5:
		spike()
		amount = 0.0

func activate():
	for npc in targets:
		if is_instance_valid(npc):
			npc.follow_target = self.get_path()
			npc.wandering = false
			npc.movement_freeze = true

func spike():
	if targets.size() > 0:
		var counter: int = 0
		for npc in targets:
			if is_instance_valid(npc):
				if npc.movement_freeze:
					if npc.current_health[0] - 10.0 < 0.0:
						npc.health_manage(-10.0)
						targets.erase(npc)
						return
					else:
						npc.health_manage(-10.0)
			else:
				targets.remove_at(counter)
			counter += 1
		counter = 0


func _on_hypnotize_area_body_entered(body: Node3D) -> void:
	if body is MovableNpc:
		if body.fraction != 1 && body.fraction != 2:
			targets.append(body)
			hold_on = true


func _on_hypnotize_area_body_exited(body: Node3D) -> void:
	if body is MovableNpc:
		if body.fraction != 1 && body.fraction != 2:
			if targets.has(body) && !body.movement_freeze:
				targets.erase(body)
			hold_on = false
