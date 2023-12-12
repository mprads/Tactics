extends Node2D

@export var unit_scene: PackedScene

# this feels wrong, perhaps this should be in an autoload
# but these are only level dependant so autoload also seems incorrect
@onready var navigation_controller = $"../NavigationController"
@onready var tile_controller = $"../TileController"

var previous_mouse_pos
var resource_party: Array[UnitStats] = []
var party: Array[Node2D] = []
#TODO: implement proper states, finite state machine may be too far
var game_state: String = "waiting"
var selected_unit: Node2D

func _ready() -> void:
	previous_mouse_pos = get_global_mouse_position()
	tile_controller.generate_map(10, 10)
	resource_party = UnitPool.get_all()
	_generate_party()

	selected_unit = party[0]

	GameEvents.move_started.connect(_on_move_started)
	GameEvents.move_ended.connect(_on_move_ended)


func _process(delta: float) -> void:
	# once state machine is in place change check to find move state
	if get_global_mouse_position() != previous_mouse_pos:
		if selected_unit:
			var mouse_position = get_global_mouse_position()
			var path_to_mouse = navigation_controller.create_id_path(mouse_position, selected_unit.global_position)
			tile_controller.draw_arrow_along_path(path_to_mouse)

func _input(event) -> void:
	if game_state == "waiting":

		if event.is_action_pressed("show_moveable") && selected_unit != null:
			tile_controller.flood_fill_hover_tiles(selected_unit.global_position, selected_unit.get_move_distance(), true)

		if event.is_action_pressed("left_click") && selected_unit != null:
			handle_left_click()


func handle_left_click() -> void:
	# base node changed from node to node2d in order to use global mouse position.
	# there should be a way to get the global position from the viewport without chaning to node2d
	var mouse_position = get_global_mouse_position()

	var selected_tile = navigation_controller.convert_world_position_to_id(mouse_position)
	var selected_tile_data = tile_controller.get_tile_data(selected_tile)
	var tile_has_unit = selected_tile_data["unit"]

	if tile_has_unit:
		selected_unit = tile_has_unit
		GameEvents.emit_unit_selected(selected_unit)
		return
	else:
		var id_path = navigation_controller.create_id_path(mouse_position, selected_unit.global_position)
		if id_path.size() > selected_unit.get_move_distance():
			return

		var world_path = navigation_controller.convert_id_path_to_world_positions(id_path)
		selected_unit.set_path(world_path)
		tile_controller.clear_layer("hover_layer")
		# this should be handled somewhere else, not sure where, probably a signal of unit move in autoload events
		tile_controller.update_tile_data(navigation_controller.convert_world_position_to_id(selected_unit.global_position), "unit", null)
		tile_controller.update_tile_data(id_path[id_path.size() - 1], "unit", selected_unit)


func _generate_party():
	var count = 0
	for unit in resource_party:
		var unit_instance = _generate_unit(unit)
		var player_party = get_tree().get_first_node_in_group("PlayerParty")
		unit_instance.global_position = navigation_controller.convert_id_to_world_position(Vector2i(0, count))
		tile_controller.update_tile_data(Vector2i(0, count), "unit", unit_instance)
		player_party.add_child(unit_instance)
		party.push_back(unit_instance)
		count += 1


func _generate_unit(unit: UnitStats) -> Node2D:
	var unit_instance = unit_scene.instantiate()
	unit_instance.set_unit_type(unit)
	return unit_instance


func _on_move_started() -> void:
	game_state = "moving"


func _on_move_ended() -> void:
	game_state = "waiting"

