
extends State
class_name PlayerAttack

# Handles two-attack-combo
var can_use_second_attack := false
var is_second_attack_queued := false

var attack1_active_frames = [2, 3]
var attack2_active_frames = [2]

@onready var player: Player = $"../.."
@onready var sprite: AnimatedSprite2D = $"../../Sprites/AnimatedSprite2D"

#Timers
@onready var attack_movement_timer: Timer = $Timers/AttackMovementTimer
@onready var second_attack_window: Timer = $Timers/SecondAttackWindow #Input buffer
@onready var enemy_hit_audio: AudioStreamPlayer2D = $"../../Melee/EnemyHitAudioPlayer"
@onready var sword_swing_audio: AudioStreamPlayer2D = $"../../Melee/SwordSwingAudioPlayer"

var target_direction

func _ready():
	sprite.connect("frame_changed", self.on_frame_changed)
	sprite.connect("animation_finished", self._on_sprite_animation_finished)

func enter():
	
	set_attack_direction()
	
	player.velocity = Vector2.ZERO
	var anim = get_attack_animation("attack1")
	sprite.play(anim)
	play_random_sound_pitch(sword_swing_audio)
	
	player.velocity = target_direction.normalized() * 500
	attack_movement_timer.start()

func set_attack_direction():
	if TargetManager.current_target:
		target_direction = (TargetManager.current_target.collider.global_position - player.global_position)
		player.last_direction = target_direction
	else:
		target_direction = player.last_direction

func start_attack2():
	is_second_attack_queued = false
	var anim = get_attack_animation("attack2")
	sprite.play(anim)
	play_random_sound_pitch(sword_swing_audio)
	player.velocity = target_direction.normalized() * 500
	attack_movement_timer.start()

# ------------------------------------------------------------
# Choose correct animation based on player's facing direction
# ------------------------------------------------------------
func get_attack_animation(base: String) -> String:
	var direction = target_direction

	if direction == Vector2.ZERO:
		return base + "_front"

	if abs(direction.x) > abs(direction.y):
		sprite.flip_h = direction.x < 0
		return base + "_side"
	elif direction.y < 0:
		return base + "_back"
	else:
		return base + "_front"

# ------------------------------------------------------------

func on_frame_changed():
	
	# activates hitbox on specific animation frame
	if sprite.animation.begins_with("attack1") and sprite.frame in attack1_active_frames:
		can_use_second_attack = true
		player.current_active_hitbox.monitoring = true
	elif sprite.animation.begins_with("attack2") and sprite.frame in attack2_active_frames:
		player.current_active_hitbox.monitoring = true
	else:
		player.current_active_hitbox.monitoring = false

func physics_update(_delta: float) -> void:
	
	set_attack_direction()
	
	if can_use_second_attack and Input.is_action_just_pressed("attack"):
		
		# if the timer already started 
		if second_attack_window.time_left > 0:
			start_attack2()
		else:
			is_second_attack_queued = true


func _on_sprite_animation_finished() -> void:
	if sprite.animation.begins_with("attack1"):
		if is_second_attack_queued:
			start_attack2()
		else:
			second_attack_window.start()
			exit_state()
	elif sprite.animation.begins_with("attack2"):
		can_use_second_attack = false
		is_second_attack_queued = false
		exit_state()
		


func _on_second_attack_window_timeout() -> void:
	can_use_second_attack = false
	is_second_attack_queued = false


func on_hitbox_area_entered(enemy: Area2D) -> void:
	if enemy is EnemyHurtbox:
		ScreenShake.screen_shake(4, 0.5)
		enemy.recieve_damage()
		player.bullet_meter.win_bullet()

		play_random_sound_pitch(enemy_hit_audio)
	
	if enemy is Breakable:
		enemy.on_hit()

func play_random_sound_pitch(audio_player: AudioStreamPlayer2D):
	var pitches := [0.9, 1.0, 1.1]
	audio_player.pitch_scale = pitches.pick_random()
	audio_player.play()

func exit_state():
	print("should exit player attack state")
	Transitioned.emit(self, "PlayerIdle")

func _on_attack_movement_timer_timeout() -> void:
	player.velocity = Vector2.ZERO

func _on_vertical_attack_area_area_entered(area: Area2D) -> void:
	on_hitbox_area_entered(area)

func _on_horizontal_attack_area_area_entered(area: Area2D) -> void:
	on_hitbox_area_entered(area)
