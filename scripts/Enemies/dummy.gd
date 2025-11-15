extends Node

@onready var hurtbox = $Hurtbox
@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	hurtbox.connect("damage_received", on_damage_received)

func on_damage_received():
	sprite.stop()
	sprite.play("hit")
