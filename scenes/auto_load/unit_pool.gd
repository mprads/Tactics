extends Node
#TODO: turn this into a weighted table
@export var pool: Array[UnitStats] = []


func get_random() -> UnitStats:
	return pool[0]


func get_all() -> Array[UnitStats]:
	return pool
