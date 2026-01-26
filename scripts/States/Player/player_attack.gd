
extends State
class_name PlayerAttack

# Handles two-attack-combo
var combo_window_open := false
var next_attack_queued := false

var attack_active_frames = [1, 2, 3]
var ignore_input_this_frame = false
var current_attack_phase = AttackPhase.NONE

@onready var player: Player = $"../.."
@onready var sprite: AnimatedSprite2D = $"../../Sprites/AnimatedSprite2D"

#Timers
@onready var attack_movement_timer: Timer = $Timers/AttackMovementTimer
@onready var second_attack_window: Timer = $Timers/SecondAttackWindow #Input buffer
@onready var sword_swing_audio: AudioStreamPlayer2D = $"../../Melee/SwordSwingAudioPlayer"
@onready var sword_swing_heavy_audio: AudioStreamPlayer2D = $"../../Melee/SwordSwingHeavy"

enum AttackPhase {
	NONE,
	ATTACK1,
	ATTACK2,
	ATTACK3
}

var target_direction

func _ready():
	sprite.connect("frame_changed", self.on_frame_changed)
	sprite.connect("animation_finished", self._on_sprite_animation_finished)

func enter():
	set_attack_direction()
	player.velocity = Vector2.ZERO
	
	if combo_window_open:
		return
	
	start_attack1()

func start_next_attack():
	match current_attack_phase:
		AttackPhase.NONE:
			start_attack1()
		
		AttackPhase.ATTACK1:
			start_attack2()
		
		AttackPhase.ATTACK2:
			start_attack3()
		
		AttackPhase.ATTACK3:
			current_attack_phase = AttackPhase.NONE

func start_attack1():
	current_attack_phase = AttackPhase.ATTACK1
	ignore_input_this_frame = true
	handle_attack("attack1")

func set_attack_direction():
	if TargetManager.current_target:
		target_direction = (TargetManager.current_target.collider.global_position - player.global_position)
		player.last_direction = target_direction
	else:
		target_direction = get_global_mouse_position() - player.global_position

func start_attack2():
	current_attack_phase = AttackPhase.ATTACK2
	next_attack_queued = false
	combo_window_open = false
	handle_attack("attack2")
	

func start_attack3():
	current_attack_phase = AttackPhase.ATTACK3
	next_attack_queued = false
	combo_window_open = false
	handle_attack("attack3") # for now we play the first animation, attack3 animation pending
	

func handle_attack(animation: String):
	var anim = get_attack_animation(animation)
	sprite.play(anim)
	
	var move_distance
	
	if current_attack_phase == AttackPhase.ATTACK3:
		sword_swing_heavy_audio.play()
		move_distance = 600
	else:
		RandomizePitch.play(sword_swing_audio)
		move_distance = 500
		
	player.velocity = target_direction.normalized() * move_distance
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
	handle_combo_by_frame()
	update_attack_hitbox()
	

func handle_combo_by_frame():
	if sprite.animation.begins_with("attack1"):
		if sprite.frame > 3:
			combo_window_open = true
		
		if combo_window_open and next_attack_queued:
			start_attack2()
	
		return
	
	if sprite.animation.begins_with("attack2"):
		if sprite.frame > 4:
			combo_window_open = true
		
		if combo_window_open and next_attack_queued:
			start_attack3()
			
		return

func update_attack_hitbox():
	# every attack has the same attack active frames for now
	if sprite.animation.begins_with("attack") and sprite.frame in attack_active_frames:
		player.current_active_hitbox.monitoring = true

	else:
		player.current_active_hitbox.monitoring = false


func physics_update(_delta: float) -> void:
	set_attack_direction()
	if ignore_input_this_frame:
		ignore_input_this_frame = false
		return
	
	if Input.is_action_just_pressed("attack"):
		if combo_window_open:
			start_next_attack()
			#start_attack2()
		elif sprite.animation.begins_with("attack1") or sprite.animation.begins_with("attack2"):
			next_attack_queued = true


func _on_sprite_animation_finished() -> void:
	# this means no second attack was pressed
	if sprite.animation.begins_with("attack1"):
		second_attack_window.start()
		exit_state()
		
	else:
		if sprite.animation.begins_with("attack2"):
			second_attack_window.start()
			
		exit_state()
		
func _on_second_attack_window_timeout() -> void:
	combo_window_open = false
	next_attack_queued = false

func on_hitbox_area_entered(enemy: Area2D) -> void:
	if enemy is EnemyHurtbox:
		var shake_intensity = 4
		var attack_push_force = 50
		
		if current_attack_phase == AttackPhase.ATTACK3:
			shake_intensity = 8
			Hitstop.freeze_frame(0.2, 0.2)
			attack_push_force = 150
			
		ScreenShake.screen_shake(shake_intensity, 0.5)
		
		enemy.recieve_damage(attack_push_force)
		player.bullet_meter.win_bullet()
	
	if enemy is Breakable:
		enemy.on_hit()

func exit_state():
	Transitioned.emit(self, "PlayerIdle")

func _on_attack_movement_timer_timeout() -> void:
	player.velocity = Vector2.ZERO

func _on_vertical_attack_area_area_entered(area: Area2D) -> void:
	on_hitbox_area_entered(area)

func _on_horizontal_attack_area_area_entered(area: Area2D) -> void:
	on_hitbox_area_entered(area)

func can_shoot() -> bool:
	return false
