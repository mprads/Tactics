extends Node2D

@export var tile_map: TileMap

var ground_source = 0
var ground_layer = 0

var hover_source = 1
var hover_layer = 1

var mouse_layer = 2

var attack_atlas = Vector2i(0, 0)
var move_atlas = Vector2i(1, 0)
var mouse_atlas = Vector2i(2, 0)

var last_mouse_pos: Vector2

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()

	if mouse_pos == last_mouse_pos:
		return

	last_mouse_pos = mouse_pos
	update_mouse_hover(mouse_pos)



func show_moveable_tiles(player_pos: Vector2) -> void:
	tile_map.set_cell(hover_layer, tile_map.local_to_map(player_pos), hover_source, move_atlas)


func update_mouse_hover(mouse_pos: Vector2) -> void:
	var new_pos = tile_map.local_to_map(mouse_pos)
	tile_map.clear_layer(mouse_layer)
	tile_map.set_cell(mouse_layer, new_pos, hover_source, mouse_atlas)
