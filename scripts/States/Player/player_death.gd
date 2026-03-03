extends State
class_name PlayerDeath

@onready var player: Player = $"../.."
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

signal player_death()

func enter():
	player.velocity = Vector2.ZERO
	player.can_move = false
	death_sound.play()
	player.animated_sprite_2d.play("death")


func _on_animated_sprite_2d_animation_finished() -> void:
	if player.animated_sprite_2d.animation == "death":
		player.set_physics_process(false)
		player.set_process(false)
		player.collision_layer = 0
		player.visible = false
		player_death.emit()
