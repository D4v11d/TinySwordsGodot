extends State
class_name EnemyFollow

@export var enemy: CharacterBody2D
@export var move_speed := 100.0
var player: CharacterBody2D

func enter():
	player = get_tree().get_first_node_in_group("Player")
	
func physics_update(delta: float):
	if enemy.velocity.length() > 0:
		enemy.sprite.play("walk")
		
	var direction = player.global_position - enemy.global_position
	
	enemy.velocity = direction.normalized() * move_speed
	
	if direction.length() > 300:
		Transitioned.emit(self, "EnemyIdle")
