class_name EnemyHurtbox
extends Area2D

signal damage_received
signal parry_stagger
signal push_received

@export var id: int

func recieve_damage():
	damage_received.emit()

func handle_parry_stagger():
	parry_stagger.emit()

func recieve_push(push_force: int):
	push_received.emit(push_force)
