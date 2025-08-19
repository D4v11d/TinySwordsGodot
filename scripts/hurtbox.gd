class_name EnemyHurtbox extends Area2D

@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

func recieve_damage():
	sprite.stop()
	sprite.play("hit")
