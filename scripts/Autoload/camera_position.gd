# File: camera_lock_controller.gd
extends Node

@onready var player: Player = get_node("/root/Game/Player")

var camera_lerp_speed: float = 0.7
var is_locked: bool = false

func _process(delta: float) -> void:
	pass #update_camera()

func lock_on_target() -> void:
	is_locked = true

func remove_target_lock() -> void:
	is_locked = false

func update_camera() -> void:
	if not player or not player.camera:
		return

	var desired_position: Vector2
	var target := TargetManager.current_target

	if is_locked and target != null:
		# midpoint must be recalculated every frame since both move
		desired_position = (player.global_position + target.global_position) * 0.5
	else:
		# auto-fallback if target disappears
		is_locked = false
		desired_position = player.global_position

	player.camera.global_position = player.camera.global_position.lerp(
		desired_position,
		camera_lerp_speed
	)
