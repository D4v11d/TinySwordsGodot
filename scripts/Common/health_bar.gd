class_name Health
extends TextureProgressBar

var max_health := 0
var current_health := 0

@onready var character: CharacterBody2D = $".."
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var damage_bar: TextureProgressBar = $DamageBar
@onready var damage_timer: Timer = $DamageTimer

signal on_death

func _ready() -> void:
	max_health = max_value
	current_health = max_health

	# Barra principal
	health_bar.max_value = max_health
	health_bar.value = current_health

	# Barra de daño
	damage_bar.max_value = max_health
	damage_bar.value = current_health

func recieve_damage(damage: int) -> void:
	var prev_health := current_health

	current_health = clamp(current_health - damage, 0, max_health)
	health_bar.value = current_health

	if current_health < prev_health:
		damage_timer.start()
	else:
		damage_bar.value = current_health

	verify_death()

func _on_damage_timer_timeout() -> void:
	damage_bar.value = current_health

func verify_death() -> void:
	if current_health <= 0:
		on_death.emit()
