extends State
class_name PlayerShoot

@onready var player: Player = $"../.."
@onready var crosshair: Sprite2D = $"../../ShootingManager/Crosshair"
@onready var shooting_bar: TextureProgressBar = $"../../ShootingManager/ShootingBar"

# Sounds
@onready var shoot_sound: AudioStreamPlayer2D = $"../../ShootingManager/ShootSound"
@onready var shoot_ready_sound: AudioStreamPlayer2D = $"../../ShootingManager/ShootReadySound"
@onready var shoot_charging_sound: AudioStreamPlayer2D = $"../../ShootingManager/ShootChargingSound"
@onready var no_bullets_sound: AudioStreamPlayer2D = $"../../ShootingManager/NoBulletsSound"


const PROGRESS_BAR_SHOOT_FULL = preload("res://assets/FX/progress-bar-shoot-full.png")
const PROGRESS_BAR_SHOOT_FULL_LIGHT = preload("res://assets/FX/progress-bar-shoot-full-light.png")
const CHARGE_SPEED := 200.0 # 100 / 0.5s

enum ChargeState {
	IDLE,
	CHARGING,
	READY
}

var charge_state: ChargeState = ChargeState.IDLE

var charging_with_bullets := true

func enter():
	player.animated_sprite_2d.stop() # set shooting animation

func update(_delta: float):
	
	var shoot_direction = get_global_mouse_position() - player.global_position
	var sprite = player.animated_sprite_2d
	
	if player.is_jumping or player.is_falling:
		return
		
	if abs(shoot_direction.x) > abs(shoot_direction.y):
		sprite.play("idle_side")
		sprite.flip_h = shoot_direction.x < 0
	elif shoot_direction.y < 0:
		sprite.play("idle_back")
	else:
		sprite.play("idle_front")

func physics_update(delta: float) -> void:
	crosshair.global_position = get_global_mouse_position()

	if Input.is_action_pressed("shoot"):
		if charge_state == ChargeState.IDLE:
			start_charging()
		elif charge_state == ChargeState.CHARGING:
			update_charging(delta)

	if Input.is_action_just_released("shoot"):
		if charge_state == ChargeState.READY:
			release_shot()
		else:
			stop_charging()
			Transitioned.emit(self, "PlayerIdle")

func start_charging() -> void:
	player.speed = player.player_speed_while_charging

	shooting_bar.visible = true
	shooting_bar.value = 0
	crosshair.visible = true

	charging_with_bullets = player.bullet_meter.bullet_number > 0

	if charging_with_bullets:
		shoot_charging_sound.play()
	else:
		no_bullets_sound.play()
		player.bullet_meter.shake()

	charge_state = ChargeState.CHARGING

func update_charging(delta: float) -> void:
	if not charging_with_bullets:
		return

	shooting_bar.value += CHARGE_SPEED * delta

	if shooting_bar.value >= shooting_bar.max_value:
		shooting_bar.value = shooting_bar.max_value
		on_charge_complete()

func on_charge_complete() -> void:
	charge_state = ChargeState.READY

	shoot_charging_sound.stop()
	shoot_ready_sound.play()

	shooting_bar.texture_progress = PROGRESS_BAR_SHOOT_FULL_LIGHT

func release_shot() -> void:

	if not player.infinite_bullets:
		decrease_bullet()

	var mouse_position = get_global_mouse_position()
	var bullet = preload("res://scenes/bullet.tscn").instantiate()
	var enemy_target = TargetManager.current_target

	stop_charging()

	bullet.global_position = player.global_position
	get_node("../../..").add_child(bullet)

	var shoot_direction = mouse_position
	if enemy_target:
		shoot_direction = enemy_target.global_position

	bullet.shoot(shoot_direction)
	RandomizePitch.play(shoot_sound)
	
	Transitioned.emit(self, "PlayerShootRecoil")

func stop_charging() -> void:
	charge_state = ChargeState.IDLE

	player.speed = player.player_base_speed
	crosshair.visible = false
	shoot_charging_sound.stop()
	
	hide_shooting_bar()

func hide_shooting_bar():
	shooting_bar.visible = false
	shooting_bar.value = 0
	shooting_bar.texture_progress = PROGRESS_BAR_SHOOT_FULL

func decrease_bullet() -> void:
	player.bullet_meter.lose_bullet()

func exit():
	stop_charging()

func can_attack() -> bool:
	return true
