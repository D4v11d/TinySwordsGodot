class_name Combat extends Node

# body could be either a Player or Enemy
var body_inside_attack_area = false
var attacking := false
var body_to_attack: GameCharacter # Player or Enemy 

@onready var character: CharacterBody2D = $".."
@onready var attack_area: Area2D = $"../AttackArea"
@onready var animated_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# connect to attack_area signals
	attack_area.body_entered.connect(on_attack_area_body_entered)
	attack_area.body_exited.connect(on_attack_area_body_exited)
	
	# connect to animated_sprite signals
	animated_sprite.animation_finished.connect(_on_attack_animation_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if body_inside_attack_area:
		attack()

func attack() -> void:
	attacking = true
	if character is Player:
		animated_sprite.play("attack_side") # damage on animation end
	elif character is Enemy:
		animated_sprite.play("attack") # damage on animation end


func on_attack_area_body_entered(body: GameCharacter) -> void:
	if body.entity_type != character.entity_type: # Avoids friendly fire
		body_to_attack = body
		body_inside_attack_area = true


func on_attack_area_body_exited(body: Node2D) -> void:
	if body:
		body_to_attack = null
		body_inside_attack_area = false


func _on_attack_animation_finished() -> void:
	attacking = false 
	
	# only damages enemy when it's inside the attack area at the animation end
	if body_to_attack:
		body_to_attack.health.recieve_damage(body_to_attack.attack_damage)
