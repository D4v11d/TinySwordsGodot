
# (TO DO: define GameCharacter class, extend it from Player and Enemy)
class_name Enemy extends GameCharacter

var player_inside_chase_area := false
var is_knocked_back := false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_player_area: Area2D = $AttackArea
@onready var player: Player = $"../../Player"
@onready var combat: Combat = $Combat
@onready var target = $Target
@onready var knockback_timer: Timer = $KnockbackTimer

@export var running_speed = 50
@export var damage = 50

func _ready() -> void:
	speed = running_speed
	entity_type = "enemy"
	attack_damage = damage
	health = $Health
	
func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta) # allows enemy to be pushed back
	if player_inside_chase_area and !combat.attacking:
		move_towards_player(delta)


func move_towards_player(delta: float) -> void:
	if is_knocked_back:
		return
		
	var direction = (player.position - position).normalized()
	velocity = speed * direction
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
		velocity = Vector2.ZERO

func toggle_target():
	target.visible = !target.visible

func receive_damage(damage: float, knockback_force: Vector2):
	health.recieve_damage(damage)
	velocity = knockback_force
	knockback_timer.start()
	is_knocked_back = true


func _on_knockback_timer_timeout() -> void:
	velocity = Vector2.ZERO
	is_knocked_back = false
