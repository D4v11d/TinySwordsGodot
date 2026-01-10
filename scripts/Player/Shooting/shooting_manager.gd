class_name ShootingManager extends Node2D

@onready var player: Player = $".."
@onready var enemy_aiming_manager: EnemyAimingManager = $"../EnemyAimingManager"

#Timers 
@onready var destroy_timer: Timer = $Timers/DestroyTimer
@onready var start_charging: Timer = $Timers/StartCharging
@onready var charging: Timer = $Timers/Charging
@onready var shooting_frequency: Timer = $Timers/ShootingFrequency

@onready var charging_particles: CPUParticles2D = $ChargingParticles
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var crosshair: Sprite2D = $Crosshair

var shot_is_charged := false
var can_shoot := true

func _physics_process(_delta: float) -> void:
	
	# crosshair follows mouse pointer
	crosshair.global_position = get_global_mouse_position()
	
	if player.bullet_meter.bullet_number == 0:
		return
		
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
		
		decrease_bullet()
		
		if not can_shoot:
			start_charging.stop()
			return
		
		can_shoot = false
		shooting_frequency.start()
		
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


func _on_shooting_frequency_timeout() -> void:
	can_shoot = true

func decrease_bullet() -> void:
	player.bullet_meter.lose_bullet()
