class_name Combat extends Node

var attacking := false
var bodies_to_attack: Array[GameCharacter] # Player or Enemy 

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
	if target_exists():
		attack()

func attack() -> void:
	attacking = true
	if character is Player:
		animated_sprite.play("attack_side") # damage on animation end
	elif character is Enemy:
		animated_sprite.play("attack") # damage on animation end


func target_exists() -> int:
	return bodies_to_attack.size() > 0


func on_attack_area_body_entered(body: GameCharacter) -> void:
	if body.entity_type != character.entity_type: # Avoids friendly fire
		bodies_to_attack.append(body)


func on_attack_area_body_exited(body: Node2D) -> void:
	if body:
		bodies_to_attack.erase(body)


func _on_attack_animation_finished() -> void:
	attacking = false 
	
	# only damages enemy when it's inside the attack area at the animation end
	if target_exists():
		#for index in bodies_to_attack.size(): # attacks groups of enemies
		bodies_to_attack[0].health.recieve_damage(character.attack_damage) # attack one by one
