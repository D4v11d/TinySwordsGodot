extends Node2D

@onready var player: Player = $"../.."
@onready var rope: Rope = $Rope

# Handles rope direction and rotation
func _physics_process(_delta: float):
	if rope.extending:
		if player.grapple_point:
			look_at(player.grapple_point.global_position)
