extends State
class_name PlayerShootRecoil

@onready var player: Player = $"../.."
@onready var shoot_recoil_timer: Timer = $ShootRecoilTimer

func enter():
	player.velocity = Vector2.ZERO
	player.animated_sprite_2d.stop() # -> should play "recoil" when it exists
	shoot_recoil_timer.start()
	player.can_move = false
	
	# This state will play the shooting recoil animation while stopping the player from moving

func _on_shoot_recoil_timer_timeout() -> void:
	Transitioned.emit(self, "PlayerIdle")
	player.can_move = true
