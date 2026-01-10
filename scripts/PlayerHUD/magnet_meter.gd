class_name MagnetMeter
extends TextureProgressBar

@export var fill_speed := 0.15

func _ready() -> void:
	min_value = 0.0
	max_value = 1.0
	value = 0.0
	step = 0.0 

func _process(delta: float) -> void:
	value += fill_speed * delta
	value = clamp(value, min_value, max_value)

func spend_magnet_meter(amount: float) -> bool:
	if value >= amount:
		value -= amount
		return true
	return false
