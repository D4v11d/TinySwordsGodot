extends Node

@onready var hurtbox = $Hurtbox
@onready var sprite = $AnimatedSprite2D
@onready var warp_strike_indicator: Sprite2D = $WarpStrikeIndicator

func _ready() -> void:
	hurtbox.connect("damage_received", on_damage_received)

func on_damage_received():
	sprite.stop()
	sprite.play("hit")

func show_warp_strike_indicator():
	warp_strike_indicator.visible = true
	
func hide_warp_strike_indicator():
	warp_strike_indicator.visible = false
