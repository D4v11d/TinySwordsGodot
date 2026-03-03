extends Label

@export var move_distance: float = 40.0
@export var fade_time: float = 0.4
@export var stay_time: float = 0.8

var _original_position: Vector2


func _ready() -> void:
	_original_position = position
	modulate.a = 0.0
	visible = false


func show_stage(stage_number: int) -> void:
	# Cambiar texto
	text = "Stage %d" % stage_number
	
	# Reset visual
	position = _original_position
	modulate.a = 0.0
	visible = true
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	# Fade in + subir
	tween.parallel().tween_property(self, "modulate:a", 1.0, fade_time)
	tween.parallel().tween_property(
		self, 
		"position", 
		_original_position - Vector2(0, move_distance), 
		fade_time
	)

	# Esperar un poco arriba
	tween.tween_interval(stay_time)

	# Fade out
	tween.parallel().tween_property(self, "modulate:a", 0.0, fade_time)
	tween.parallel().tween_property(
		self, 
		"position", 
		_original_position - Vector2(0, move_distance * 1.3), 
		fade_time
	)

	# Al terminar ocultar
	tween.finished.connect(func():
		visible = false
		position = _original_position
	)
