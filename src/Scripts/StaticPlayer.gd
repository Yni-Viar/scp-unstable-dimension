extends Node3D
## Static player
## Made by Yni, licensed under MIT License.
class_name StaticPlayer

var mouse_sensitivity = 0.03125
var prev_x_coordinate: float = 0
var scroll_factor: float = 1.0
var target_puppet_path: String = ""

const RAY_LENGTH = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("look"):
			# https://kidscancode.org/godot_recipes/3.x/3d/camera_gimbal/index.html
			rotate_object_local(Vector3.UP, event.relative.x * mouse_sensitivity * 0.05)
			var y_rotation = clamp(event.relative.y, -30, 30)
			$Head.rotate_object_local(Vector3.RIGHT, y_rotation * mouse_sensitivity * 0.05)
			$Head.rotation_degrees.x = clamp($Head.rotation_degrees.x, -90, 0)
			#rotation.y -= event.relative.x * mouse_sensitivity * 0.05
			#rotation.x -= event.relative.y * mouse_sensitivity * 0.05
			#rotation_degrees.y = clamp(rotation_degrees.y, -90, 90)
	if event is InputEventScreenDrag:
		# https://kidscancode.org/godot_recipes/3.x/3d/camera_gimbal/index.html
		rotate_object_local(Vector3.UP, event.relative.x * mouse_sensitivity * 0.05)
		var y_rotation = clamp(event.relative.y, -30, 30)
		$Head.rotate_object_local(Vector3.RIGHT, y_rotation * mouse_sensitivity * 0.05)
		$Head.rotation_degrees.x = clamp($Head.rotation_degrees.x, -90, 0)
	if event.is_action_pressed("scroll_up"):
		scroll_factor += 0.125
		scroll_factor = clamp(scroll_factor, 1.0, 8.0)
		$Head/Camera3D.fov = 75.0 / scroll_factor
	if event.is_action_pressed("scroll_down"):
		scroll_factor -= 0.125
		scroll_factor = clamp(scroll_factor, 1.0, 8.0)
		$Head/Camera3D.fov = 75.0 / scroll_factor
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		interact("Point")
	if !target_puppet_path.is_empty():
		if get_node_or_null(target_puppet_path) == null:
			get_tree().root.get_node("Game").finish_game(false, "GAME_OVER_1")
		else:
			if get_node(target_puppet_path).current_health[2] < get_node(target_puppet_path).health[2]:
				$Head/Camera3D/MeshInstance3D.mesh.surface_get_material(0).set_shader_parameter("multiplier", (get_node(target_puppet_path).health[2] - get_node(target_puppet_path).current_health[2]) / get_node(target_puppet_path).health[2])
			get_tree().root.get_node("Game/UI/HealthBar").value = get_node(target_puppet_path).current_health[0]

## Used from Godot Docs
func intersect() -> Dictionary:
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = $Head/Camera3D.project_ray_origin(mousepos)
	var end = origin + $Head/Camera3D.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)

	return space_state.intersect_ray(query)

func interact(value: String) -> void:
	match value:
		"Point":
			var result: Dictionary = intersect()
			if result.keys().size() > 0:
				if get_node_or_null(target_puppet_path) == null:
					get_tree().root.get_node("Game").finish_game(false, "GAME_OVER_1")
				if !get_node(target_puppet_path).movement_freeze:
					get_node(target_puppet_path).set_target_position(result["position"], true)
