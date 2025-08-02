class_name RopeManager extends Node2D

@onready var player: Player = $".."
@onready var rope: Rope = $"../RopePivot/Rope"

# Handles player movement when hooked
func _physics_process(delta: float) -> void:
	if rope.retracting:
		var target = rope.target_position

		if player.position.distance_to(target) > 10.0:
			player.is_hooked = true
			var direction = (target - player.position).normalized()
			player.position += direction * rope.retract_speed * delta
	else:
		player.is_hooked = false
