extends Node2D
class_name ResourceMeter

@export var resource_points: Array[ResourcePoint]

@export var shake_distance := 6.0
@export var shake_duration := 0.12

@export var resource_number := 5

var original_position: Vector2
var shake_tween: Tween

signal health_is_zero

func _ready():
	original_position = position

func restore_full_health() -> void:
	resource_number = 4 # health will be variable in the future
	for point in resource_points:
		if point != null:
			point.fill_point()

func win_point():
	print("winning bullet - bullet number is: ", resource_number)
	if resource_number < 5:
		resource_points[resource_number].fill_point()
		resource_number = resource_number + 1
	
	handle_low_health_animation()
	
func lose_point():		
	if resource_number > 0:
		resource_points[resource_number - 1].empty_point()
		resource_number = resource_number - 1
		
		if resource_number == 0:
			health_is_zero.emit()
	
	handle_low_health_animation()

func handle_low_health_animation():
	if resource_number == 1:
		resource_points[0].play_low_health_animation()
	else:
		resource_points[0].stop_low_health_animation()


func shake():
	if shake_tween and shake_tween.is_running():
		shake_tween.kill()

	global_position = original_position

	shake_tween = create_tween()
	shake_tween.set_trans(Tween.TRANS_SINE)
	shake_tween.set_ease(Tween.EASE_OUT)

	shake_tween.tween_property(
		self,
		"position",
		original_position + Vector2(shake_distance, 0),
		shake_duration * 0.25
	)
	shake_tween.tween_property(
		self,
		"position",
		original_position + Vector2(-shake_distance, 0),
		shake_duration * 0.5
	)
	shake_tween.tween_property(
		self,
		"position",
		original_position,
		shake_duration * 0.25
	)
