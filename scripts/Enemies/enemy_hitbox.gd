extends Node
class_name EnemyHitbox

@onready var enemy: CharacterBody2D = $".."
@onready var state_machine: StateMachine = $"../StateMachine"

var player: Player

var is_player_on_hitbox := false

func _physics_process(_delta: float) -> void:
	if player and not player.melee_attack_manager.is_parry_activated:
		player.recieve_damage(enemy)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		is_player_on_hitbox = true
		player = body
		var current_state = state_machine.current_state
		
		# stop after charging against enemy
		if current_state is EnemyCharge:
			state_machine._on_state_transition(current_state, "EnemyIdle")
			
func _on_body_exited(_body: Node2D) -> void:
	is_player_on_hitbox = false
	player = null
