class_name EnemyHurtbox
extends Area2D

signal damage_received

@export var id: int

func recieve_damage():
	emit_signal("damage_received")
