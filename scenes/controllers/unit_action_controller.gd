extends Node

var selected_unit: CharacterBody2D


func _ready() -> void:
	selected_unit = get_tree().get_first_node_in_group("PlayerUnits")


func get_selected_unit() -> CharacterBody2D:
	return selected_unit
