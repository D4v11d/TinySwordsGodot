class_name Player extends CharacterBody2D

const SPEED = 200.0

var is_attacking := false
var is_charging_attack := false
var enemy_is_on_attack_area := false

var current_attacked_enemies: Array[Enemy] = []
var target_position := Vector2()
var click_position := Vector2()

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var attack_charge_timer: Timer = $AttackChargeTimer
@onready var health: Health = $Health

func _ready() -> void:
	click_position = position

func _physics_process(_delta: float) -> void:
	
	handle_movement()
		
	handle_attack()
	
	if health.current_health <= 0:
		queue_free()


func _input(event:InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			click_position = get_global_mouse_position()


func handle_movement() -> void:
	# var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# movement direction & animation
	if position.distance_to(click_position) > 3:
		if !is_attacking:
			target_position = (click_position - position).normalized()
			velocity = target_position * SPEED
			animated_sprite_2d.play("run_side")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		if !is_attacking:
			animated_sprite_2d.play("idle")
	
	# flip sprite direction
	if target_position.x > 0:
		animated_sprite_2d.flip_h = false
		attack_area.scale.x = 1
	elif target_position.x < 0:
		animated_sprite_2d.flip_h = true
		attack_area.scale.x = -1
	move_and_slide()
	
func handle_attack() -> void:
	if Input.is_action_just_pressed("ui_accept") and velocity.length() < 3:
		animated_sprite_2d.play("attack_side")
		is_attacking = true
		velocity = velocity.move_toward(Vector2.ZERO, SPEED) #stop movement
	
	# charge attack for some seconds and release
	if Input.is_action_pressed("attack") and !is_charging_attack:
		is_charging_attack = true
		print("attack charging")
		attack_charge_timer.start()
	
	if Input.is_action_just_released("attack"):
		print("time left: ", attack_charge_timer.time_left)
		if attack_charge_timer.is_stopped():
			print("attack released")
		attack_charge_timer.stop()
		is_charging_attack = false
		

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "attack_side":
		if enemy_is_on_attack_area:
			for index in current_attacked_enemies.size():
				current_attacked_enemies[index].health.recieve_damage(30)
	is_attacking = false


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		enemy_is_on_attack_area = true
		current_attacked_enemies.append(body)

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body is Enemy:
		current_attacked_enemies.erase(body)
		if(current_attacked_enemies.size() == 0):
			enemy_is_on_attack_area = false
