extends Node

var using_controller: bool = true


func _process(_delta: float) -> void:
	check_controller_connection()


func check_controller_connection() -> void:
	var joypads := Input.get_connected_joypads()

	if joypads.is_empty():
		using_controller = false
