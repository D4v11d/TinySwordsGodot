# res://states/enemy_follow.gd
extends State
class_name EnemyFollow

@export var enemy: CharacterBody2D

# Distance behavior
@export var min_radius := 200.0
@export var max_radius := 300.0
@export var radius_buffer := 25.0

# Decision control (ANTI-JITTER)
@export var decision_interval := 0.4

# Orbit / wandering
@export var reposition_time := 1.5
@export var target_reach_distance := 20.0

var player: CharacterBody2D
var move_target: Vector2

var decision_timer := 0.0
var reposition_timer := 0.0

enum MovementMode { APPROACH, RETREAT, ORBIT }
var mode: MovementMode = MovementMode.ORBIT

@onready var charge_frequency: Timer = $"../../ChargeFrequency"
@onready var wait_before_charge_timer: Timer = $"../../WaitBeforeChargeTimer"

@onready var walk_sound: AudioStreamPlayer2D = $WalkSound
@onready var walk_sound_timer: Timer = $WalkSoundTimer


func enter():
	#walk_sound.play()
	#walk_sound_timer.start()
	player = get_tree().get_first_node_in_group("Player")

	if charge_frequency.time_left == 0:
		init_charge_frequency_timer()

	decision_timer = 0.0
	reposition_timer = 0.0
	pick_new_move_target()

	if enemy.velocity.length() > 0:
		enemy.sprite.play("walk")

#func exit():
	#walk_sound_timer.stop()

func physics_update(delta: float):
	if not is_instance_valid(player):
		Transitioned.emit(self, "EnemyIdle")
		return

	var to_player = player.global_position - enemy.global_position
	var distance = to_player.length()

	decision_timer -= delta
	if decision_timer <= 0.0:
		decision_timer = decision_interval
		update_movement_mode(distance)

	match mode:
		MovementMode.APPROACH:
			enemy.velocity = to_player.normalized() * enemy.move_speed

		MovementMode.RETREAT:
			enemy.velocity = -to_player.normalized() * enemy.move_speed

		MovementMode.ORBIT:
			handle_orbit(delta)

	if distance > 2000:
		Transitioned.emit(self, "EnemyIdle")

func update_movement_mode(distance: float):
	if distance > max_radius + radius_buffer:
		mode = MovementMode.APPROACH
		return

	if distance < min_radius - radius_buffer:
		mode = MovementMode.RETREAT
		return

	mode = MovementMode.ORBIT

func handle_orbit(delta: float):
	reposition_timer -= delta

	if reposition_timer <= 0.0 \
	or enemy.global_position.distance_to(move_target) <= target_reach_distance:
		pick_new_move_target()

	var dir = (move_target - enemy.global_position).normalized()
	enemy.velocity = dir * enemy.move_speed

func pick_new_move_target():
	reposition_timer = reposition_time

	if not is_instance_valid(player):
		return

	var angle = randf_range(0, TAU)
	var radius = randf_range(min_radius, max_radius)

	move_target = player.global_position + Vector2(
		cos(angle),
		sin(angle)
	) * radius

func init_charge_frequency_timer():
	charge_frequency.wait_time = randf_range(1.2, 2)
	charge_frequency.start()

func on_charge_frequency_timeout() -> void:
	wait_before_charge_timer.start()
	Transitioned.emit(self, "EnemyWindUp")


#func _on_walk_sound_timer_timeout() -> void:
	#RandomizePitch.play(walk_sound)
