extends Node
class_name BulletMeter

@export var bullet_points: Array[BulletPoint]

var bullet_number := 5

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
