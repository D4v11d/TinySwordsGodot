extends CharacterBody2D
class_name EnemyDino


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: EnemyHurtbox = $Hurtbox
@onready var state_machine: StateMachine = $StateMachine
@onready var knockback_timer: Timer = $KnockbackTimer
@onready var hitstop: Hitstop = $Hitstop
@onready var health: Health = $Health
@onready var charge_frequency: Timer = $ChargeFrequency
@onready var warp_strike_indicator: Sprite2D = $WarpStrikeIndicator
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var target: Sprite2D = $Target
@onready var flash_animation: AnimationPlayer = $FlashAnimation
@onready var parry_sound: AudioStreamPlayer2D = $ParrySound
@onready var enemy_hit_audio_player: AudioStreamPlayer2D = $EnemyHitAudioPlayer

@export var is_invincible := false
@export var should_follow := false
@export var base_speed := 130

var knockback_speed = 50;
var original_knockback_speed = 50
var is_stunned = false
var move_speed := base_speed

func _ready():
	# Connect the signal from the hurtbox
	hurtbox.connect("damage_received", on_damage_received)
	hurtbox.connect("parry_stagger", on_parry_stagger)
	hurtbox.connect("push_received", on_push_received)
	charge_frequency.timeout.connect(_on_charge_frequency_timeout)
	
	TargetManager.register_enemy(self)

func _physics_process(delta: float) -> void:	
	
	if velocity.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
		
	move_and_collide(velocity * delta)
	

func on_damage_received(player_push_force: float):	
	# Manually transition to knockback state when hit
	var current_state = state_machine.current_state
	if current_state is not EnemyCharge:
		knockback_speed = player_push_force
		state_machine._on_state_transition(state_machine.current_state, "EnemyKnockback")
		knockback_timer.start()
	else:
		flash_animation.play("flash")
	
	if not is_invincible:
		#DamageNumbers.display_text("20", health.global_position)
		health.recieve_damage(20)
		RandomizePitch.play(enemy_hit_audio_player)

func on_parry_stagger():
	# can only parry if enemy is charging
	if state_machine.current_state is EnemyCharge:
		print("the enemy was parried successfully")
		parry_sound.play()
		ScreenShake.screen_shake(4, 0.25)
		Hitstop.freeze_frame(0.05, 0.6)
		is_stunned = true
		state_machine._on_state_transition(state_machine.current_state, "EnemyKnockback")
		knockback_timer.start()
		# I need to refactor, timeout should be handled inside knockback state
		# Then out here we handle the parry stagger timer, that will make the enemy
		# freeze for some time
		# parry_stager_timer.start()

func on_push_received(push_force):
	knockback_speed = push_force
	state_machine._on_state_transition(state_machine.current_state, "EnemyKnockback")
	knockback_timer.start()

func _on_charge_frequency_timeout():
	var current_state = state_machine.current_state
	if current_state and current_state.has_method("on_charge_frequency_timeout"):
		current_state.on_charge_frequency_timeout()

func show_warp_strike_indicator():
	warp_strike_indicator.visible = true
	
func hide_warp_strike_indicator():
	warp_strike_indicator.visible = false

func toggle_target():
	target.visible = !target.visible
