extends State
class_name EnemyFollow

@export var enemy: CharacterBody2D
@export var move_speed := 200.0
var player: CharacterBody2D
@onready var charge_frequency: Timer = $"../../ChargeFrequency"

func enter():
	player = get_tree().get_first_node_in_group("Player")
	print("charge timer time left is: ", charge_frequency.time_left)
	if charge_frequency.time_left == 0:
		init_charge_frequency_timer()
	
func physics_update(_delta: float):
	if enemy.velocity.length() > 0:
		enemy.sprite.play("walk")
		
	var direction = player.global_position - enemy.global_position
	
	enemy.velocity = direction.normalized() * move_speed
	
	if direction.length() > 2000:
		Transitioned.emit(self, "EnemyIdle")

func init_charge_frequency_timer():
	charge_frequency.start()
	
func on_charge_frequency_timeout() -> void:
	Transitioned.emit(self, "EnemyCharge")
