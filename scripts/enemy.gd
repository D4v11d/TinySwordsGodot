
# (TO DO: define GameCharacter class, extend it from Player and Enemy)
class_name Enemy extends GameCharacter

var player_inside_chase_area = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_player_area: Area2D = $AttackArea
@onready var player: Player = $"../Player"
@onready var combat: Combat = $Combat

func _ready() -> void:
	speed = 80.0
	entity_type = "enemy"
	attack_damage = 20
	health = $Health
	
func _physics_process(delta: float) -> void:		
	if player_inside_chase_area and !combat.attacking:
		move_towards_player(delta)


func move_towards_player(delta: float) -> void:
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
