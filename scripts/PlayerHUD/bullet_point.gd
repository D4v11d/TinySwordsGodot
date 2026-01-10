extends Node
class_name BulletPoint

@onready var full_bullet_sprite: Sprite2D = $FullBulletSprite
@onready var empty_bullet_sprite: Sprite2D = $EmptyBulletSprite

func fill_point():
	full_bullet_sprite.visible = true
	empty_bullet_sprite.visible = false

func empty_point():
	full_bullet_sprite.visible = false
	empty_bullet_sprite.visible = true
