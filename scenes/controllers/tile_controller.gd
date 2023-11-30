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

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()

	if mouse_pos == last_mouse_pos:
		return

	last_mouse_pos = mouse_pos
	update_mouse_hover(mouse_pos)


func flood_fill_hover_tiles(pos: Vector2, max_distance: int) -> void:
	var starting_pos: Vector2i = tile_map.local_to_map(pos)
	var tiles: Array[Vector2i] = []
	var stack: Array[Vector2i] = [starting_pos]

	while not stack.is_empty():
		var current_tile: Vector2i = stack.pop_back()

		# Need to figure out how to check bounds of ground layer
		if current_tile in tiles:
			continue

		var difference: Vector2i = (current_tile - starting_pos).abs()
		var distance: int = int(difference.x + difference.y)
		if distance > max_distance:
			continue

		tiles.append(current_tile)

		for direction in DIRECTIONS:
			var next_tile: Vector2i = current_tile + direction
			#once figured out grid data storing check if occupied
			if next_tile in tiles:
				continue

			stack.append(next_tile)
	for tile in tiles:
		tile_map.set_cell(hover_layer, tile, hover_source, move_atlas)




func clear_layer(layer_name: String) -> void:
	match layer_name:
		"ground_layer":
			tile_map.clear_layer(ground_layer)
		"hover_layer":
			tile_map.clear_layer(hover_layer)
		"mouse_layer":
			tile_map.clear_layer(mouse_layer)


func update_mouse_hover(mouse_pos: Vector2) -> void:
	var new_pos = tile_map.local_to_map(mouse_pos)
	tile_map.clear_layer(mouse_layer)
	tile_map.set_cell(mouse_layer, new_pos, hover_source, mouse_atlas)
