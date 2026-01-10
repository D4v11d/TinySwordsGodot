extends State
class_name EnemyCharge

@export var enemy: CharacterBody2D

@onready var charge_timer: Timer = $"../../ChargeTimer"
@onready var contact_hitbox: EnemyHitbox = $"../../ContactHitbox"

var player: CharacterBody2D
var charge_direction: Vector2
var run_speed := 650.0

func enter():
	player = get_tree().get_first_node_in_group("Player")
	enemy.sprite.play("charge")
	charge_timer.start()
	charge_direction = player.global_position - enemy.global_position
	contact_hitbox.monitoring = true
	
func physics_update(_delta: float):
	enemy.velocity = charge_direction.normalized() * run_speed

func _on_charge_timer_timeout() -> void:
	contact_hitbox.monitoring = false
	Transitioned.emit(self, "EnemyIdle")
