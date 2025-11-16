
extends State
class_name PlayerAttack

# Handles two-attack-combo
var can_use_second_attack := false
var is_second_attack_queued := false

var attack1_active_frames = [2, 3]
var attack2_active_frames = [2]

@onready var player: Player = $"../.."
@onready var sprite: AnimatedSprite2D = $"../../Sprites/AnimatedSprite2D"
@onready var hitbox: Area2D = $"../../AttackArea"

# Input buffer
@onready var second_attack_window: Timer = $"../../SecondAttackWindow"

func _ready():
	sprite.connect("frame_changed", self.on_frame_changed)
	sprite.connect("animation_finished", self._on_sprite_animation_finished)

func enter():
	var anim = get_attack_animation("attack1")
	sprite.play(anim)

func start_attack2():
	is_second_attack_queued = false
	var anim = get_attack_animation("attack2")
	sprite.play(anim)

# ------------------------------------------------------------
# Choose correct animation based on player's facing direction
# ------------------------------------------------------------
func get_attack_animation(base: String) -> String:
	var direction = player.player_direction

	if direction == Vector2.ZERO:
		direction = player.last_direction
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
		hitbox.monitoring = true
	elif sprite.animation.begins_with("attack2") and sprite.frame in attack2_active_frames:
		hitbox.monitoring = true
	else:
		hitbox.monitoring = false

func physics_update(delta: float) -> void:
	if can_use_second_attack and Input.is_action_just_pressed("attack"):
		
		# if the timer already started 
		if second_attack_window.time_left > 0:
			sprite.play(get_attack_animation("attack2"))
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


func _on_attack_area_area_entered(enemy: Area2D) -> void:
	if enemy is EnemyHurtbox:
		enemy.recieve_damage()


func _on_attack_area_area_exited(area: Area2D) -> void:
	pass # Replace with function body.

func exit_state():
	print("should exit player attack state")
	Transitioned.emit(self, "PlayerIdle")
