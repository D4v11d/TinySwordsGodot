# res://states/enemy_windup.gd
extends State
class_name EnemyWindUp

@onready var enemy_dino: EnemyDino = $"../.."
@onready var dino_charge_indicator: Sprite2D = $"../../DinoChargeIndicator"

var wind_up_speed := 0.0
var player: CharacterBody2D
var charge_direction := Vector2.ZERO

func enter():
	
	player = get_tree().get_first_node_in_group("Player")
	enemy_dino.velocity = Vector2.ZERO
	enemy_dino.sprite.play("charging")

	dino_charge_indicator.visible = true
	update_charge_indicator()

func physics_update(_delta: float):
	if not is_instance_valid(player):
		return

	update_charge_indicator()

func update_charge_indicator():
	charge_direction = (player.global_position - enemy_dino.global_position).normalized()

	dino_charge_indicator.global_position = enemy_dino.global_position
	dino_charge_indicator.rotation = charge_direction.angle()

func _on_wait_before_charge_timer_timeout() -> void:
	Transitioned.emit(self, "EnemyCharge")
