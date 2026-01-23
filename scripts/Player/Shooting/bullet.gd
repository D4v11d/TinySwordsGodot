class_name Bullet extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var explode_area: Area2D = $ExplodeArea

var is_moving := false
var direction = Vector2.ZERO
var speed := 800
var damage := 20

var is_charged := false
var knockback_power := 300.0

var enemy_hit_by_bullet: Area2D = null

func _physics_process(_delta: float) -> void:
	if is_moving:
		velocity = direction * speed
		move_and_slide()

func shoot(target_position: Vector2):
	direction = (target_position - global_position).normalized()
	is_moving = true

func hit_something(enemy) -> void:
	enemy_hit_by_bullet = enemy;
	animated_sprite_2d.play("explode")
	velocity = Vector2.ZERO
	is_moving = false
	
	if is_charged:
		explode_area.monitoring = true;
		knockback_power = 400.0
	
	if enemy is EnemyHurtbox:
		on_enemy_hit(enemy)
	
	if enemy is Breakable:
		enemy.on_hit()

func on_enemy_hit(enemy):
	var knockback_direction = (enemy.position - self.global_position).normalized()
	var knockback_force = knockback_direction * knockback_power
	enemy.recieve_damage(50) #knockback_force

# process ends when bullet stops exploding.
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "explode":
		queue_free()

# if bullet doesn't explode on contact, delete after a while
func _on_destroy_timer_timeout() -> void:
	queue_free()

func _on_bullet_area_area_entered(area: Area2D) -> void:
	if area is EnemyHurtbox or area is Breakable:
		hit_something(area)


func _on_explode_area_area_entered(area: Area2D) -> void:
	if area is EnemyHurtbox or area is Breakable:
		if enemy_hit_by_bullet != area:
			area.recieve_damage()
