extends CharacterBody2D

@onready var hurtbox = $Hurtbox
@onready var sprite = $AnimatedSprite2D
@onready var warp_strike_indicator: Sprite2D = $WarpStrikeIndicator
@onready var target: Sprite2D = $Target
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var damage_numbers_position: Node2D = $DamageNumbersPosition

func _ready() -> void:
	hurtbox.connect("damage_received", on_damage_received)
	TargetManager.register_enemy(self)

func on_damage_received(_push_force: float):
	sprite.stop()
	sprite.play("hit")
	#DamageNumbers.display_text("20", damage_numbers_position.global_position)

func show_warp_strike_indicator():
	warp_strike_indicator.visible = true
	
func hide_warp_strike_indicator():
	warp_strike_indicator.visible = false


func toggle_target():
	target.visible = !target.visible
