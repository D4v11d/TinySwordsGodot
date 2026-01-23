extends Node

const DAMAGE_FONT := preload("res://assets/Fonts/m5x7.ttf")

const YELLOW_CHANCE := 0.25
const MAX_ROTATION_DEG := 45.0

# Scatter config
var _scatter_angle := 10
const SCATTER_STEP := PI * 20
const SCATTER_JITTER := PI 
const SCATTER_RADIUS_MIN := 20.0
const SCATTER_RADIUS_MAX := 30.0


func display_text(value: String, position: Vector2):
	var number := Label.new()

	# ---- SCATTER CONTROLADO ----
	var jitter := randf_range(-SCATTER_JITTER, SCATTER_JITTER)
	_scatter_angle += SCATTER_STEP + jitter

	var radius := randf_range(SCATTER_RADIUS_MIN, SCATTER_RADIUS_MAX)
	var offset := Vector2(
		cos(_scatter_angle),
		sin(_scatter_angle)
	) * radius
	# ----------------------------

	number.global_position = position + offset
	number.text = value
	number.z_index = 5

	# Rotación ligera aleatoria
	number.rotation = deg_to_rad(randf_range(-MAX_ROTATION_DEG, MAX_ROTATION_DEG))

	var settings := LabelSettings.new()
	settings.font = DAMAGE_FONT
	settings.font_size = 32
	#settings.font_color = _get_random_damage_color()
	settings.outline_color = Color.BLACK
	settings.outline_size = 4

	number.label_settings = settings

	call_deferred("add_child", number)
	await play_tween_animation(number)
	number.queue_free()


func play_tween_animation(label: Label, y_offset := 20.0, duration := 0.7) -> void:
	await get_tree().process_frame
	label.pivot_offset = label.size * 0.5

	var tween := get_tree().create_tween()
	tween.set_parallel(true)

	tween.tween_property(
		label,
		"position:y",
		label.position.y - y_offset,
		duration
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	tween.tween_property(
		label,
		"modulate:a",
		0.3,
		duration
	)

	await tween.finished


func _get_random_damage_color() -> Color:
	if randf() <= YELLOW_CHANCE:
		return Color(1.0, 0.9, 0.3)
	return Color.WHITE
