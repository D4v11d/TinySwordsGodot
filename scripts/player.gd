
# (TO DO: define GameCharacter class, extend it from Player and Enemy)
class_name Player extends GameCharacter

var target_position := Vector2()
var click_position := Vector2()

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var attack_charge_timer: Timer = $AttackChargeTimer
@onready var combat: Combat = $Combat

func _ready() -> void:
	# Game character variables
	speed = 200.0
	entity_type = "player"
	attack_damage = 30
	health = $Health
	
	# Player variables
	click_position = position

func _physics_process(_delta: float) -> void:
	handle_movement()


func _input(event:InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			click_position = get_global_mouse_position()


func handle_movement() -> void:
	# var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# movement direction & animation
	if position.distance_to(click_position) > 3:
		if !combat.attacking:
			target_position = (click_position - position).normalized()
			velocity = target_position * speed
			animated_sprite_2d.play("run_side")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		if !combat.attacking:
			animated_sprite_2d.play("idle")
	
	# flip sprite direction
	if target_position.x > 0:
		animated_sprite_2d.flip_h = false
		attack_area.scale.x = 1
	elif target_position.x < 0:
		animated_sprite_2d.flip_h = true
		attack_area.scale.x = -1
	move_and_slide()
