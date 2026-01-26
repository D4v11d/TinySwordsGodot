extends Sprite2D

@export var appear_duration := 0.25
@export var levitation_height := 6.0
@export var levitation_duration := 1.2

var _levitation_tween: Tween

func _ready() -> void:
	start_levitation()


func start_levitation() -> void:
	if _levitation_tween:
		_levitation_tween.kill()

	var start_y := position.y

	_levitation_tween = create_tween()
	_levitation_tween.set_trans(Tween.TRANS_SINE)
	_levitation_tween.set_ease(Tween.EASE_IN_OUT)
	_levitation_tween.set_loops()

	_levitation_tween.tween_property(
		self,
		"position:y",
		start_y - levitation_height,
		levitation_duration * 0.5
	)

	_levitation_tween.tween_property(
		self,
		"position:y",
		start_y,
		levitation_duration * 0.5
	)
