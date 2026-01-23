extends State
class_name PlayerIdle

@onready var player: Player = $"../.."

func update(_delta: float):
	var last_direction =  player.last_direction
	var sprite = player.animated_sprite_2d
	
	if player.is_jumping or player.is_falling:
		return
		
	if abs(last_direction.x) > abs(last_direction.y):
		sprite.play("idle_side")
		sprite.flip_h = last_direction.x < 0
	elif last_direction.y < 0:
		sprite.play("idle_back")
	else:
		sprite.play("idle_front")

func physics_update(_delta: float):
	
	if player.player_direction != Vector2.ZERO:
		Transitioned.emit(self, "PlayerMove")
	
