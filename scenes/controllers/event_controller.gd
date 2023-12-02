extends Node2D

# this feels wrong, perhaps this should be in an autoload
# but these are only level dependant so autoload also seems incorrect
@onready var unit_action_controller = $"../UnitActionController"
@onready var navigation_controller = $"../NavigationController"
@onready var tile_controller = $"../TileController"

var previous_mouse_pos

func _ready() -> void:
	previous_mouse_pos = get_global_mouse_position()
	tile_controller.generate_map(10, 10)


func _process(delta: float) -> void:
	# once state machine is in place change check to find move state
	if get_global_mouse_position() != previous_mouse_pos:
		var player = unit_action_controller.get_selected_unit()
		var mouse_position = get_global_mouse_position()
		var path_to_mouse = navigation_controller.create_id_path(mouse_position, player.global_position)
		tile_controller.draw_arrow_along_path(path_to_mouse)

func _input(event) -> void:
	if event.is_action_pressed("show_moveable") && unit_action_controller.get_selected_unit() != null:
		var player = unit_action_controller.get_selected_unit()
		tile_controller.flood_fill_hover_tiles(player.global_position, player.get_move_distance(), true)

	if event.is_action_pressed("move") && unit_action_controller.get_selected_unit() != null:
		var player = unit_action_controller.get_selected_unit()
		# base node changed from node to node2d in order to use global mouse position.
		# there should be a way to get the global position from the viewport without chanign to node2d
		var mouse_position = get_global_mouse_position()
		var id_path = navigation_controller.create_id_path(mouse_position, player.global_position)
		var world_path = navigation_controller.convert_id_path_to_world_positions(id_path)
		player.set_path(world_path)
		tile_controller.clear_layer("hover_layer")
		# this should be handled somewhere else, not sure where, probably a signal of unit move in autoload events
		tile_controller.update_tile_data(navigation_controller.convert_world_position_to_id(player.global_position), "occupied")
		tile_controller.update_tile_data(id_path[id_path.size() - 1], "occupied")



