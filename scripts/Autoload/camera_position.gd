extends Node

@onready var player: Player = get_node("/root/Game/Player")

var camera_lerp_speed = 0.7

# Moves camera to a midpoint between Player and target_position
func lock_on_target(target_position: Vector2):
	var mid_point = (player.global_position + target_position) / 2
	player.camera.global_position = player.camera.global_position.lerp(mid_point, camera_lerp_speed)

func remove_target_lock():
	player.camera.global_position = player.camera.global_position.lerp(player.global_position, camera_lerp_speed)
 
