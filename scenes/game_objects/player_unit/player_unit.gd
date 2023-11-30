extends CharacterBody2D

@export var stats: Resource

var current_path: Array[Vector2]


func _physics_process(delta: float) -> void:
	if current_path.is_empty():
		return

	var target_position = current_path.front()
	global_position = global_position.move_toward(target_position, 1)

	if global_position == target_position:
		current_path.pop_front()


func set_path(path: Array[Vector2]) -> void:
	print("setting path: ", path)
	current_path = path


func get_move_distance() -> int:
	return stats.movement
