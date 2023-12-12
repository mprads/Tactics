extends Node

signal unit_selected(unit: Node2D)
signal move_started()
signal move_ended()


func emit_unit_selected(unit: Node2D) -> void:
	unit_selected.emit(unit)


func emit_move_started() -> void:
	move_started.emit()


func emit_move_ended() -> void:
	move_ended.emit()
