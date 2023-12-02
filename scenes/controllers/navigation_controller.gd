extends Node

#there should be a way to grab this on load rather than storing a ref in scene
@export var tile_map: TileMap

var astar_grid: AStarGrid2D


func _ready() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(32,16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()


func create_id_path(mouse_position: Vector2, player_position: Vector2) -> Array[Vector2i]:
	var player_tile_position = tile_map.local_to_map(player_position)
	var mouse_tile_position = tile_map.local_to_map(mouse_position)
	if astar_grid.is_in_boundsv(mouse_tile_position):
		var id_path = astar_grid.get_id_path(player_tile_position, mouse_tile_position).slice(1)
#		print("created path: ", id_path)
		return id_path
	else:
		return []


func convert_world_position_to_id(pos: Vector2) -> Vector2i:
	return tile_map.local_to_map(pos)


func convert_id_path_to_world_positions(id_path: Array[Vector2i]) -> Array[Vector2]:
	var world_path: Array[Vector2]= []
	for id in id_path:
		world_path.append(tile_map.map_to_local(id))

	return world_path
