extends Node2D
class_name State

signal Transitioned

func enter():
	pass

func exit():
	pass

func update(delta: float):
	pass

func physics_update(delta: float):
	pass

# States cannot transition to Attack or Shoot by default
func can_attack() -> bool:
	return false
 
func can_shoot() -> bool:
	return false
