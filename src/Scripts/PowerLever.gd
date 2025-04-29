extends Node3D

## Enable / disable power
var enable: bool = true:
	set(val):
		enable = !enable
		enabling = true
## Is it currently enabling (needed for handling power off transition)
var enabling: bool = false
## Check for sawe value. If chaos insurgent is passing by, don't activate power off immediately.
var hold_on: bool = false
## Safe value. If chaos insurgent is passing by, don't activate power off immediately.
var amount: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if enabling:
		if !enable:
			get_tree().root.get_node("Game/WorldEnvironment").environment.ambient_light_energy -= 2.0 * delta
	if hold_on:
		amount += delta
		if amount > 4.0:
			inactivate()
			hold_on = false

func inactivate():
	$Cylinder.mesh.surface_set_material(0, load("res://Assets/Materials/InactivatedLever.tres"))
	$AnimationPlayer.play("enable")
	enable = false
	await get_tree().create_timer(2.0).timeout
	get_tree().root.get_node("Game").finish_game(false)

#func activate():
	#$Cylinder.mesh.surface_set_material(0, load("res://Assets/Materials/ActivatedLever.tres"))
	#$AnimationPlayer.play("enable")


func _on_detect_area_body_entered(body: Node3D) -> void:
	if body is MovableNpc:
		if body.fraction == 3:
			hold_on = true


func _on_detect_area_body_exited(body: Node3D) -> void:
	if body is MovableNpc:
		if body.fraction == 3:
			hold_on = false
			amount = 0.0
