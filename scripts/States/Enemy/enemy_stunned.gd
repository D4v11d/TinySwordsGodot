extends State
class_name EnemyStunned

@export var enemy: CharacterBody2D
@onready var stun: AnimatedSprite2D = $"../../Stun"

var stun_duration := 1.5

func enter():
	enemy.velocity = Vector2.ZERO
	enemy.sprite.play("stunned")
	stun.visible = true
	stun.play("stun")

	# Create a one-shot timer
	var timer := get_tree().create_timer(stun_duration)
	timer.timeout.connect(_on_stun_finished)

func _on_stun_finished():
	enemy.is_stunned = false
	stun.visible = false
	Transitioned.emit(self, "EnemyIdle")
	
