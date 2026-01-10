class_name EnemyAimingManager
extends Node2D

@onready var player: Player = $".."

const SWITCH_TARGET_MAX_DISTANCE := 500.0
const UNLOCK_TARGET_MAX_DISTANCE := 650.0

func _physics_process(_delta: float) -> void:
	handle_lock_target()
	handle_auto_unlock()

	if TargetManager.current_target and Input.is_action_just_pressed("switch"):
		handle_switch_target()

func handle_lock_target() -> void:
	if not Input.is_action_just_pressed("lock"):
		return

	if TargetManager.current_target:
		remove_target()
		return

	var enemy := get_closest_enemy()
	if not enemy:
		return

	apply_target(enemy)

func handle_switch_target() -> void:
	var enemy := get_closest_enemy(
		TargetManager.current_target
	)

	if not enemy:
		return

	apply_target(enemy)

func handle_auto_unlock() -> void:
	if not TargetManager.current_target:
		return

	var player_pos := player.global_position
	var target_pos := TargetManager.current_target.global_position
	var dist_sq := player_pos.distance_squared_to(target_pos)

	if dist_sq > UNLOCK_TARGET_MAX_DISTANCE * UNLOCK_TARGET_MAX_DISTANCE:
		remove_target()

func get_closest_enemy(exclude: EnemyDino = null) -> EnemyDino:
	var closest: EnemyDino = null
	var min_distance := INF
	var player_pos := player.global_position
	var max_dist_sq := SWITCH_TARGET_MAX_DISTANCE * SWITCH_TARGET_MAX_DISTANCE

	for enemy in TargetManager.enemies:
		if enemy == exclude:
			continue

		var dist := player_pos.distance_squared_to(enemy.global_position)
		if dist > max_dist_sq:
			continue

		if dist < min_distance:
			min_distance = dist
			closest = enemy

	return closest

func apply_target(new_target: EnemyDino) -> void:
	if TargetManager.current_target:
		TargetManager.current_target.toggle_target()

	new_target.toggle_target()
	TargetManager.current_target = new_target
	CameraPosition.lock_on_target(new_target.global_position)

func remove_target() -> void:
	if not TargetManager.current_target:
		return

	TargetManager.current_target.toggle_target()
	TargetManager.current_target = null
	CameraPosition.remove_target_lock()
