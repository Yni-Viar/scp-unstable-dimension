extends Node3D
## Made by Yni, licensed under CC0.
class_name BasePuppetScript

@export var armature_name: String = "HumanRig"
enum States {IDLE, WALKING, RUNNING, SPECIAL1, SPECIAL2, SPECIAL3, SPECIAL4}
@export var state: States = States.IDLE
@export var enable_vision_scan: bool = false
@export var vision_class_detect: int = 0
var active_puppets: Array[Node3D] = []

func _ready() -> void:
	# Inventory items
	on_start()

func on_start():
	pass
