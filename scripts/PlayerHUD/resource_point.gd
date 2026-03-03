extends Node
class_name ResourcePoint

@onready var full_sprite: AnimatedSprite2D = $FullSprite
@onready var empty_sprite: Sprite2D = $EmptySprite

func fill_point():
	full_sprite.visible = true
	empty_sprite.visible = false

func empty_point():
	full_sprite.visible = false
	empty_sprite.visible = true

func play_low_health_animation():
	full_sprite.play("low_health")

func stop_low_health_animation():
	full_sprite.play("default")
	
