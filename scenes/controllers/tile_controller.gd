extends Node2D

@export var tile_map: TileMap

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

var ground_source = 0
var ground_layer = 0
var ground_atlas = Vector2i(0, 0)

var hover_source = 1
var hover_layer = 1

var mouse_layer = 2

var arrow_layer = 3
var arrow_terrain_set = 0
var arrow_terrain = 0

var attack_atlas = Vector2i(0, 0)
var move_atlas = Vector2i(1, 0)
var mouse_atlas = Vector2i(2, 0)

var last_mouse_pos: Vector2

var grid = {}

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()

	if mouse_pos == last_mouse_pos:
		return

	last_mouse_pos = mouse_pos
	update_mouse_hover(mouse_pos)


func generate_map(x: int, y: int) -> void:
	for i in x:
		for j in y:
			grid[str(Vector2i(i, j))] = {
				"occupied": false
			}
			tile_map.set_cell(ground_layer, Vector2i(i, j), ground_source, ground_atlas)


func flood_fill_hover_tiles(pos: Vector2, max_distance: int, exclude_occupided: bool = false) -> void:
	var starting_pos: Vector2i = tile_map.local_to_map(pos)
	var tiles: Array[Vector2i] = []
	var stack: Array[Vector2i] = [starting_pos]

	while not stack.is_empty():
		var current_tile: Vector2i = stack.pop_back()

		if current_tile in tiles:
			continue
		elif !grid.has(str(current_tile)):
			continue
		elif exclude_occupided && grid[str(current_tile)]["occupied"] && current_tile != starting_pos:
			continue

		var distance: int = get_difference_between_tiles(starting_pos, current_tile)
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
	if grid.has(str(new_pos)):
		tile_map.clear_layer(mouse_layer)
		tile_map.set_cell(mouse_layer, new_pos, hover_source, mouse_atlas)


func draw_arrow_along_path(id_path: Array[Vector2i]) -> void:
	tile_map.clear_layer(arrow_layer)
	tile_map.set_cells_terrain_connect(arrow_layer, id_path, arrow_terrain_set, arrow_terrain)


func update_tile_data(id: Vector2i, key) -> void:
	grid[str(id)][key] = !grid[str(id)][key]


func get_difference_between_tiles(starting: Vector2i, end: Vector2i) -> int:
	var difference: Vector2i = (end - starting).abs()
	return int(difference.x + difference.y)
