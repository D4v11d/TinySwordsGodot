extends State
class_name EnemyDeath

@export var enemy: EnemyDino
@onready var hitstop: Hitstop = $"../../Hitstop"
@onready var death_timer: Timer = $DeathTimer
@onready var flash_animation: AnimationPlayer = $"../../FlashAnimation"
@onready var state_machine: StateMachine = $".."
@onready var death_sound: AudioStreamPlayer2D = $DeathSound
@onready var dino_charge_indicator: Sprite2D = $"../../DinoChargeIndicator"

var player: CharacterBody2D
var is_slowing_down := false
var decel_rate := 2000.0 

# ! knockback state code is duplicated !

func enter():
	
	death_timer.start()
	player = get_tree().get_first_node_in_group("Player")
	enemy.sprite.stop()
	enemy.sprite.play("hit")
	flash_animation.play("flash")
	is_slowing_down = false
	death_sound.play()
	dino_charge_indicator.visible = false
	
	enemy.hurtbox.monitorable = false
	enemy.hurtbox.monitoring = false
	enemy.hurtbox.get_node("CollisionShape2D").set_deferred("disabled", true)

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
	enemy.visible = false # should disable collision too

func _on_death_timer_timeout() -> void:
	is_slowing_down = true

func _on_death_sound_finished() -> void:
	enemy.queue_free()
