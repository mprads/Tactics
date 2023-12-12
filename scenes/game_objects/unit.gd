extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var unit_stats: UnitStats
var current_path: Array[Vector2]
var is_moving: bool = false
var is_selected: bool = false


func _ready() -> void:
	GameEvents.unit_selected.connect(_on_selected_unit)

	if unit_stats == null:
		return

	_set_texture()


func _process(delta: float) -> void:
	if !is_selected:
		return

	if current_path.is_empty():
		if is_moving:
			is_moving = false
			GameEvents.emit_move_ended()
		return

	if !is_moving:
		GameEvents.emit_move_started()
		is_moving = true

	var target_position = current_path.front()
	global_position = global_position.move_toward(target_position, 1)

	if global_position == target_position:
		current_path.pop_front()


func set_unit_type(type: UnitStats) -> void:
	if unit_stats != null:
		return

	unit_stats = type

func _set_texture() -> void:
	sprite_2d.texture = unit_stats.sprite


func set_path(path: Array[Vector2]) -> void:
	current_path = path


func get_move_distance() -> int:
	return unit_stats.movement


func get_is_moving() -> bool:
	return is_moving


func _on_selected_unit(unit: Node2D) -> void:
	if unit == self:
		is_selected = true
