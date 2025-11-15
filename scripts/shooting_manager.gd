class_name ShootingManager extends Node2D

@onready var player: Player = $".."
@onready var enemy_aiming_manager: EnemyAimingManager = $"../EnemyAimingManager"
@onready var destroy_timer: Timer = $DestroyTimer
@onready var start_charging: Timer = $"../Timers/StartCharging"
@onready var charging: Timer = $"../Timers/Charging"
@onready var charging_particles: CPUParticles2D = $"../ChargingParticles"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var shot_is_charged := false

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("shoot"):
		print("shoot just pressed")
		start_charging.start()
		# shooting was directed to targeted enemy, changed for mouse pointer
		
		#var enemy = enemy_aiming_manager.enemy
		#var enemy_position = Vector2.ZERO
		#if enemy != null:
			#print("there is enemy")
			#enemy_position = enemy.global_position
	if Input.is_action_just_released("shoot"):
		
		start_charging.stop()
		charging.stop()
		
		var mouse_position = get_global_mouse_position()
		var bullet = preload("res://scenes/bullet.tscn").instantiate()
		
		if shot_is_charged:
			# charged bullet changes
			bullet.scale = Vector2(1.5, 1.5)
			bullet.modulate = "black"
			bullet.is_charged = true
		
		stop_charging()	
		bullet.global_position = player.global_position
		get_node("../..").add_child(bullet)
		bullet.shoot(mouse_position)

# player will start charging 0.5 seconds after shoot was pressed
func _on_start_charging_timeout() -> void:
	charging.start()
	player.speed = player.player_speed_while_charging
	charging_particles.emitting = true

# player will shoot if button is released after charging timer finished
func _on_charging_timeout() -> void:
	shot_is_charged = true
	charging_particles.emitting = false
	animation_player.play("charge_blink")

func stop_charging():
	shot_is_charged = false
	player.speed = player.player_base_speed
	charging_particles.emitting = false
	animation_player.stop()
