class_name Rope extends Sprite2D

@onready var player: Player = $"../../.."

var current_length: float = 0.0

var extending: bool = false
var retracting: bool = false

var extend_speed = 2500.0
var retract_speed: float = 1600.0

var target_position = Vector2.ZERO
var target_distance = 0
var max_length := 0.0

const ROPE_WIDTH = 3

var original_texture_height := 1.0

func _ready():
	if texture:
		original_texture_height = texture.get_height()

func _process(delta):
	
	if extending:
		player.is_hooked = true
		current_length += extend_speed * delta
		
		if current_length >= max_length:
			current_length = max_length
			extending = false
	else:
		retracting = true
		current_length -= retract_speed * delta
		if current_length <= 0:
			current_length = 0
			retracting = false

	update_rope()

func update_rope():
	var scale_factor = current_length / original_texture_height
	scale.y = scale_factor

func _input(event):
	if event.is_action_pressed("hook") and player.grapple_point and not player.is_hooked:
		# Player can only hook if GrapplePoint at same elevation
		if player.grapple_point.height == player.current_elevation: 
			extending = true
			target_position = player.grapple_point.global_position
			target_distance = player.global_position.distance_to(target_position)
			max_length = player.global_position.distance_to(player.grapple_point.global_position)
