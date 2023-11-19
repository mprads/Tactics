extends Node2D

var astar_grid: AStarGrid2D
var current_id_path: Array[Vector2i]
@onready var tile_map: TileMap = $"./TileMap"

func _ready() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(32,16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()


func _physics_process(delta: float) -> void:
	if current_id_path.is_empty():
		return

	var player = get_tree().get_first_node_in_group("PlayerUnits")
	var target_position = tile_map.map_to_local(current_id_path.front())

	player.global_position = global_position.move_toward(target_position, 50)
	print(player.global_position, target_position)
	if player.global_position == target_position:
		current_id_path.pop_front()




func _input(event) -> void:
	if event.is_action_pressed("move") == false:
		return

	var player = get_tree().get_first_node_in_group("PlayerUnits")

	var player_position = tile_map.local_to_map(player.global_position)
	var mouse_position =  tile_map.local_to_map(get_global_mouse_position())
	var id_path = astar_grid.get_id_path(player_position, mouse_position).slice(1)
	if id_path.is_empty() == false:
		print(id_path)
		current_id_path = id_path

