extends Node2D
class_name BulletMeter

@export var bullet_points: Array[BulletPoint]

@export var shake_distance := 6.0
@export var shake_duration := 0.12

var bullet_number := 5

var original_position: Vector2
var shake_tween: Tween

func _ready():
	original_position = position

func win_bullet():
	print("winning bullet - bullet number is: ", bullet_number)
	if bullet_number < 5:
		bullet_points[bullet_number].fill_point()
		bullet_number = bullet_number + 1
	
func lose_bullet():
	print("losing bullet - bullet number is: ", bullet_number)
	if bullet_number > 0:
		bullet_points[bullet_number - 1].empty_point()
		bullet_number = bullet_number - 1

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
