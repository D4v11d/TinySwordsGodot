extends State
class_name EnemyWindUp

@onready var enemy_dino: EnemyDino = $"../.."
var wind_up_speed := 100
var player: CharacterBody2D

func enter():
	player = get_tree().get_first_node_in_group("Player")
	enemy_dino.sprite.play("charging")

func physics_update(_delta: float):
	
	var direction = player.global_position - enemy_dino.global_position
	enemy_dino.velocity = direction.normalized() * wind_up_speed

func _on_wait_before_charge_timer_timeout() -> void:
	Transitioned.emit(self, "EnemyCharge")
