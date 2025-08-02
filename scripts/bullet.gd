class_name Bullet extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_moving := false
var direction = Vector2.ZERO
var speed := 800
var damage := 20

func _physics_process(delta: float) -> void:
	if is_moving:
		velocity = direction * speed
		move_and_slide()

func shoot(target_position: Vector2):
	direction = (target_position - global_position).normalized()
	is_moving = true


func _on_bullet_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		animated_sprite_2d.play("explode")
		velocity = Vector2.ZERO
		is_moving = false
		
		var knockback_direction = (body.position - self.global_position).normalized()
		var knockback_force = knockback_direction * 300.0
		body.receive_damage(damage, knockback_force)


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "explode":
		queue_free()


func _on_destroy_timer_timeout() -> void:
	queue_free()
