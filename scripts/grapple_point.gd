class_name GrapplePoint extends AnimatableBody2D

@export var height = 0

@onready var grapple_from_area: Area2D = $Area2D
@onready var grapple_cursor: Sprite2D = $GrappleCursor

var time_accumulator := 0.0

func _ready() -> void:
	grapple_from_area.body_entered.connect(on_grapple_from_area_body_entered)
	grapple_from_area.body_exited.connect(on_grapple_from_area_body_exited)

func on_grapple_from_area_body_entered(body: Node2D):
	if body is Player:
		body.grapple_point = self
		#if body.current_elevation == height
		grapple_cursor.visible = true
		CameraPosition.lock_on_target(global_position)

func on_grapple_from_area_body_exited(body: Node2D):
	if body is Player:
		print("body exited area")
		body.grapple_point = null
		grapple_cursor.visible = false
		CameraPosition.remove_target_lock()
