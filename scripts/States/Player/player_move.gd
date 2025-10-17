extends State
class_name PlayerMove

@onready var player: Player = $"../.."

func enter():
	pass

func update(delta: float):
	var player_direction =  player.player_direction
	var sprite = player.animated_sprite_2d
	
	if player.is_jumping or player.is_falling:
		return
	
	print("on player move state")
	if player_direction != Vector2.ZERO:
		print("animating move")
		# Running animations based on direction
		if abs(player_direction.x) > abs(player_direction.y):
			sprite.play("run_side")
			sprite.flip_h = player_direction.x < 0
		elif player_direction.y < 0:
			sprite.play("run_back")
		else:
			sprite.play("run_front")

func physics_update(delta: float):
	if player.player_direction == Vector2.ZERO:
		Transitioned.emit(self, "PlayerIdle")
	


func _on_test_sprite_animation_finished() -> void:
	pass # Replace with function body.
