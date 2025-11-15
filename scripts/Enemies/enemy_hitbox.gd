extends Node
class_name EnemyHitbox

@onready var enemy: CharacterBody2D = $".."

var player: Player

var is_player_on_hitbox := false

func _physics_process(delta: float) -> void:
	if player:
		if not player.is_invincible:
			player.recieve_damage(enemy)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		is_player_on_hitbox = true
		player = body

func _on_body_exited(body: Node2D) -> void:
	is_player_on_hitbox = false
	player = null
