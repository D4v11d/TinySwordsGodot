class_name MeleeAttack extends Node2D

@onready var test_sprite: AnimatedSprite2D = $"../TestSprite"
@onready var player: Player = $".."
@onready var hitbox: Area2D = $"../AttackArea"
@onready var second_attack_window: Timer = $"../SecondAttackWindow"

var is_attacking := false
var can_use_second_attack := false
var is_second_attack_queued := false

var attack1_active_frames = [4]
var attack2_active_frames = [2]

func _ready():
	test_sprite.connect("frame_changed", self._on_frame_changed)

func _on_frame_changed():
	if test_sprite.animation == "attack1" and test_sprite.frame in attack1_active_frames:
		hitbox.monitoring = true
	elif test_sprite.animation == "attack2" and test_sprite.frame in attack2_active_frames:
		hitbox.monitoring = true
	else:
		hitbox.monitoring = false

func _physics_process(delta: float) -> void:
	if !is_attacking and Input.is_action_just_pressed("attack"):
		is_attacking = true
		test_sprite.play("attack1")
		can_use_second_attack = true
		return
	
	if can_use_second_attack and Input.is_action_just_pressed("attack"):
		
		# it means the timer already started 
		if second_attack_window.time_left > 0:
			test_sprite.play("attack2")
		else:
			is_second_attack_queued = true

func _on_test_sprite_animation_finished() -> void:
	
	if is_attacking and test_sprite.animation == "attack1":
		if is_second_attack_queued:
			test_sprite.play("attack2")
		else:
			second_attack_window.start()
		return
	
	if test_sprite.animation == "attack2":
		print("attack 2 animation stopped")
		is_attacking = false
		can_use_second_attack = false
		is_second_attack_queued = false
	
	
func _on_attack_area_area_entered(area: Area2D) -> void:
	if area is EnemyHurtbox:
		print("attack recieved")
		area.recieve_damage()

# 0.3s after first attack
func _on_second_attack_window_timeout() -> void: 
	if test_sprite.animation == "attack2":
		return
	
	can_use_second_attack = false
	is_attacking = false
