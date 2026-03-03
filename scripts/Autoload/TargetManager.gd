extends Node

var enemies: Array[Node2D] = []
var current_target: Node2D = null

signal all_enemies_cleared()

func register_enemy(enemy: Node2D):
	enemies.append(enemy)

func unregister_enemy(enemy: Node2D):
	enemies.erase(enemy)
	if enemy == current_target:
		current_target = null
	
	print("Enemy just died. Remaining: ", enemies.size())
	if enemies.is_empty():
		all_enemies_cleared.emit()
