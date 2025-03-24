class_name Combat extends Node

@onready var attack_area: Area2D = $"../AttackArea"
@onready var animated_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

var attacking := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func attack() -> void:
	attacking = true
	animated_sprite.play("attack") # damage on animation end
