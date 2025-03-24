class_name Enemy extends CharacterBody2D

const SPEED = 80.0
var player_inside_chase_area = false
var player_inside_attack_area = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_player_area: Area2D = $AttackArea
@onready var player: Player = $"../Player"
@onready var health: Health = $Health
@onready var combat: Combat = $Combat


func _physics_process(delta: float) -> void:
	if health.current_health <= 0:
		queue_free()
		
	if player_inside_chase_area and !combat.attacking:
		move_towards_player(delta)
		
	if player_inside_attack_area:
		combat.attack()
		
func move_towards_player(delta: float) -> void:
	var direction = (player.position - position).normalized()
	velocity = SPEED * direction
	move_and_collide(velocity * delta)
	animated_sprite.play("run")
	
	# flip sprite direction
	if direction.x > 0:
		animated_sprite.flip_h = false
		attack_player_area.scale.x = 1
	elif direction.x < 0:
		animated_sprite.flip_h = true
		attack_player_area.scale.x = -1
		

# ChasePlayerArea
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_inside_chase_area = true;
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_inside_chase_area = false;
		animated_sprite.play("idle")

# AttackPlayerArea
func _on_attack_player_area_body_entered(_body: Node2D) -> void:
	player_inside_attack_area = true
	
func _on_attack_player_area_body_exited(_body: Node2D) -> void:
	player_inside_attack_area = false
	
#function should be moved to combat
func _on_enemy_animated_sprite_animation_finished() -> void:
	combat.attacking = false 
	player.health.recieve_damage(20)
