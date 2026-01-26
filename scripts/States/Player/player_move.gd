extends State
class_name PlayerMove

@onready var player: Player = $"../.."

func enter():
	pass

func update(_delta: float):
	var player_direction =  player.player_direction
	var sprite = player.animated_sprite_2d
	
	if player.is_jumping or player.is_falling:
		return
	
	if player_direction != Vector2.ZERO:
		# Running animations based on direction
		if abs(player_direction.x) > abs(player_direction.y):
			sprite.play("run_side")
			sprite.flip_h = player_direction.x < 0

			if player_direction.x < 0:
				player.magnet_manager.change_area_positions("left")
			else:
				player.magnet_manager.change_area_positions("right")

		elif player_direction.y < 0:
			sprite.play("run_back")
			player.magnet_manager.change_area_positions("top")

		else:
			sprite.play("run_front")
			player.magnet_manager.change_area_positions("down")

func physics_update(_delta: float):

	if player.player_direction == Vector2.ZERO:
		Transitioned.emit(self, "PlayerIdle")

func can_attack() -> bool:
	return true

func can_shoot() -> bool:
	return true
