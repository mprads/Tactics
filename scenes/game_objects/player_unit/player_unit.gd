extends CharacterBody2D

@export var stats: Resource

var current_path: Array[Vector2]
var is_moving: bool = false


func _process(delta: float) -> void:
	if current_path.is_empty():
		is_moving = false
		return

	is_moving = true
	var target_position = current_path.front()
	global_position = global_position.move_toward(target_position, 1)

	if global_position == target_position:
		current_path.pop_front()


func set_path(path: Array[Vector2]) -> void:
	print("setting path: ", path)
	current_path = path


func get_move_distance() -> int:
	return stats.movement


func get_is_moving() -> bool:
	return is_moving
