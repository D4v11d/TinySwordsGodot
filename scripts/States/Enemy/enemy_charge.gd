extends State
class_name EnemyCharge

@export var enemy: CharacterBody2D

@onready var charge_timer: Timer = $"../../ChargeTimer"

var player: CharacterBody2D
var charge_direction: Vector2
var run_speed := 650.0

func enter():
	player = get_tree().get_first_node_in_group("Player")
	enemy.sprite.play("charge")
	charge_timer.start()
	charge_direction = player.global_position - enemy.global_position
	
func physics_update(delta: float):
	enemy.velocity = charge_direction.normalized() * run_speed

func _on_charge_timer_timeout() -> void:
	enemy.immune_to_knockback = false
	Transitioned.emit(self, "EnemyIdle")
