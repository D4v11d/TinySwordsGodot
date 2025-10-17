extends Node
class_name EnemyHitbox

@onready var enemy: CharacterBody2D = $".."

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.recieve_damage(enemy)
