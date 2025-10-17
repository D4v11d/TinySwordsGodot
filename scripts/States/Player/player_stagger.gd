extends State
class_name PlayerStagger

@export var knockback_speed := 700.0
@onready var player: Player = $"../.."

@onready var stagger_timer: Timer = $"../../StaggerTimer"

func enter():
	player.animated_sprite_2d.stop()
	stagger_timer.start()
	player.can_move = false
	
func physics_update(delta: float):
	player.velocity = player.knockback_direction.normalized() * knockback_speed


func _on_stagger_timer_timeout() -> void:
	player.velocity = Vector2.ZERO
	Transitioned.emit(self, "PlayerIdle")
	player.can_move = true
