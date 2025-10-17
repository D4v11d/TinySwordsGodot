
extends State
class_name PlayerAttack

# Handles two-attack-combo
var can_use_second_attack := false
var is_second_attack_queued := false

var attack1_active_frames = [4]
var attack2_active_frames = [2]

@onready var player: Player = $"../.."
@onready var sprite: AnimatedSprite2D = $"../../Sprites/TestSprite"
@onready var hitbox: Area2D = $"../../AttackArea"

# Input buffer
@onready var second_attack_window: Timer = $"../../SecondAttackWindow"

func _ready():
	sprite.connect("frame_changed", self.on_frame_changed)

func enter():
	print("attack state entered")
	sprite.play("attack1")

func start_attack2():
	is_second_attack_queued = false
	sprite.play("attack2")

func on_frame_changed():
	if sprite.animation == "attack1" and sprite.frame in attack1_active_frames:
		can_use_second_attack = true
		hitbox.monitoring = true
	elif sprite.animation == "attack2" and sprite.frame in attack2_active_frames:
		hitbox.monitoring = true
	else:
		hitbox.monitoring = false

func physics_update(delta: float) -> void:
	if can_use_second_attack and Input.is_action_just_pressed("attack"):
		
		# it means the timer already started 
		if second_attack_window.time_left > 0:
			sprite.play("attack2")
		else:
			is_second_attack_queued = true


func _on_test_sprite_animation_finished() -> void:
	if sprite.animation == "attack1":
		if is_second_attack_queued:
			start_attack2()
		else:
			second_attack_window.start()
	elif sprite.animation == "attack2":
		can_use_second_attack = false
		is_second_attack_queued = false
		exit_state()
		


func _on_second_attack_window_timeout() -> void:
	if sprite.animation != "attack2":
		can_use_second_attack = false
		exit_state()


func _on_attack_area_area_entered(area: Area2D) -> void:
	if area is EnemyHurtbox:
		area.recieve_damage()


func _on_attack_area_area_exited(area: Area2D) -> void:
	pass # Replace with function body.

func exit_state():
	print("should exit")
	Transitioned.emit(self, "PlayerIdle")
	player.melee_attack_manager.is_attacking = false

func exit():
	player.melee_attack_manager.is_attacking = false
