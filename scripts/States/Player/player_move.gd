extends State
class_name PlayerMove

@onready var player: Player = $"../.."
@onready var walk_sound: AudioStreamPlayer2D = $WalkSound
@onready var walk_sound_timer: Timer = $WalkSoundTimer

func enter():
	walk_sound.play()
	walk_sound_timer.start()

func exit():
	walk_sound_timer.stop()

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

		elif player_direction.y < 0:
			sprite.play("run_back")

		else:
			sprite.play("run_front")

func physics_update(_delta: float):

	if player.player_direction == Vector2.ZERO:
		Transitioned.emit(self, "PlayerIdle")

func can_attack() -> bool:
	return true

func can_shoot() -> bool:
	return true

func _on_walk_sound_timer_timeout() -> void:
	var pitches = [1.8, 2.0, 2.2]
	RandomizePitch.play(walk_sound, pitches)
