class_name Breakable
extends Area2D

signal destroyed

@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var crate: Crate = $".."
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var shadow: Sprite2D = $"../Shadow"

var enemies_touching: Array[EnemyHurtbox] = []

func _ready() -> void:
	set_physics_process(true)

func _physics_process(_delta: float) -> void:

	if crate.is_being_throwed and enemies_touching.size() > 0:
		on_hit()

		for enemy in enemies_touching:
			enemy.recieve_damage()
			
			# makes sure to hit only once
			enemies_touching.erase(enemy)
			monitoring = false

func on_hit() -> void:
	animation_player.stop()
	shadow.visible = false
	sprite.play("break")
	destroyed.emit()

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "break":
		crate.queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is EnemyHurtbox:
		enemies_touching.append(area)

func _on_area_exited(area: Area2D) -> void:
	if area is EnemyHurtbox:
		enemies_touching.erase(area)
