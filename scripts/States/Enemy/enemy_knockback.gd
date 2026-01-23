extends State
class_name EnemyKnockback

@export var enemy: EnemyDino
@onready var hitstop: Hitstop = $"../../Hitstop"
@onready var knockback_timer: Timer = $"../../KnockbackTimer"
@onready var flash_animation: AnimationPlayer = $"../../FlashAnimation"
@onready var vfx_animation: AnimatedSprite2D = $"../../VFXAnimation"
@onready var state_machine: StateMachine = $".."

var player: CharacterBody2D
var is_slowing_down := false
var decel_rate := 2000.0 

func enter():
	
	player = get_tree().get_first_node_in_group("Player")
	enemy.sprite.stop()
	enemy.sprite.play("hit")
	flash_animation.play("flash")
	play_impact_animation()
	is_slowing_down = false

func physics_update(_delta: float) -> void:
	if is_slowing_down:
		enemy.knockback_speed = move_toward(
			enemy.knockback_speed,
			0.0,
			decel_rate * _delta
		)

		var dir = enemy.velocity.normalized()
		enemy.velocity = dir * enemy.knockback_speed
		
		if enemy.knockback_speed <= 0.1:
			stop_knockback()
	else:
		var direction = enemy.global_position - player.global_position
		enemy.velocity = direction.normalized() * enemy.knockback_speed


func stop_knockback():
	enemy.knockback_speed = 0.0
	is_slowing_down = false
	enemy.knockback_speed = enemy.original_knockback_speed
	if enemy.is_stunned:
		Transitioned.emit(self, "EnemyStunned")
		return
	
	var last_saved_state = state_machine.last_state.name
	
	if last_saved_state == "EnemyWindUp":
		Transitioned.emit(self, last_saved_state)
		return
	
	Transitioned.emit(self, "EnemyIdle")
	

func _on_knockback_timer_timeout() -> void:
	is_slowing_down = true

func play_impact_animation():
	vfx_animation.stop()
	vfx_animation.visible = true
	vfx_animation.play("impact")

func _on_vfx_animation_animation_finished() -> void:
	vfx_animation.visible = false
