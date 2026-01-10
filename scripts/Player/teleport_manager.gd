extends Node2D
class_name TeleportManager

@onready var player: Player = $".."
@onready var state_machine: StateMachine = $"../StateMachine"

var teleport_activated := false
var warp_offset_from_enemy = 75.0
var squared_distance_to_warp_min = 50000
var squared_distance_to_warp_max = 150000

func _physics_process(_delta: float) -> void:
	free_teleport()
	
	if TargetManager.current_target:
		handle_warp_strike()

func free_teleport():
	if Input.is_action_just_pressed("teleport"):
		teleport_activated = true
		
	if Input.is_action_just_released("teleport"):
		teleport_activated = false
	
	if teleport_activated and Input.is_action_just_pressed("click"):
		var mouse_position = get_global_mouse_position()
		player.global_position = mouse_position

func handle_warp_strike():

	var enemy = TargetManager.current_target
	var enemy_pos = enemy.global_position
	var player_pos = player.global_position
	var warp_position = enemy_pos + (player_pos - enemy_pos).normalized() * warp_offset_from_enemy
	
	if enemy_is_on_warp_distance(enemy) and Input.is_action_just_pressed("warp_strike"):
		player.global_position = warp_position
		state_machine._on_state_transition(state_machine.current_state, "PlayerAttack")
		
func enemy_is_on_warp_distance(enemy):
	var enemy_pos = enemy.global_position
	var distance_to_enemy = (player.global_position - enemy_pos).length_squared()
	if distance_to_enemy > squared_distance_to_warp_min and distance_to_enemy < squared_distance_to_warp_max:
		enemy.show_warp_strike_indicator()
		return true
	
	enemy.hide_warp_strike_indicator()
	return false
