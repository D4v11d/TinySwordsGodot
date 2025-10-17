extends State
class_name EnemyKnockback

@export var enemy: CharacterBody2D
@export var knockback_speed := 100.0
@onready var hitstop: Hitstop = $"../../Hitstop"

@onready var knockback_timer: Timer = $"../../KnockbackTimer"

var player: CharacterBody2D

func enter():
	player = get_tree().get_first_node_in_group("Player")
	enemy.sprite.stop()
	enemy.sprite.play("hit")
	
func physics_update(delta: float):
	var direction = enemy.global_position - player.global_position
	enemy.velocity = direction.normalized() * knockback_speed
