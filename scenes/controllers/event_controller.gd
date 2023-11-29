extends Node2D

# this feels wrong, perhaps this should be in an autoload
# but these are only level dependant so autoload also seems incorrect
@onready var unit_action_controller = $"../UnitActionController"
@onready var navigation_controller = $"../NavigationController"
@onready var tile_controller = $"../TileController"

func _ready() -> void:
	pass

func _input(event) -> void:
	if event.is_action_pressed("show_moveable") && unit_action_controller.get_selected_unit() != null:
		var player = unit_action_controller.get_selected_unit()
		tile_controller.show_moveable_tiles(player.global_position)

	if event.is_action_pressed("move") && unit_action_controller.get_selected_unit() != null:
		var player = unit_action_controller.get_selected_unit()
		# base node changed from node to node2d in order to use global mouse position.
		# there should be a way to get the global position from the viewport without chanign to node2d
		var mouse_position = get_global_mouse_position()
		var id_path = navigation_controller.create_id_path(mouse_position, player.global_position)
		var world_path = navigation_controller.convert_id_path_to_world_positions(id_path)
		player.set_path(world_path)



