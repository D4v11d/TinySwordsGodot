extends CharacterBody2D
class_name EnemyDino

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: EnemyHurtbox = $Hurtbox
@onready var state_machine: StateMachine = $StateMachine
@onready var knockback_timer: Timer = $KnockbackTimer
@onready var hitstop: Hitstop = $Hitstop
@onready var health: Health = $Health

var immune_to_knockback: bool = false

func _ready():
	# Connect the signal from the hurtbox
	hurtbox.connect("damage_received", on_damage_received)

func _physics_process(delta: float) -> void:	
	
	if velocity.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
		
	move_and_collide(velocity * delta)

func on_damage_received():	
	# Manually transition to knockback state when hit
	
	if not immune_to_knockback:
		state_machine._on_state_transition(state_machine.current_state, "EnemyKnockback")
		knockback_timer.start()
		immune_to_knockback = true
		
	health.recieve_damage(20)


func _on_knockback_timer_timeout() -> void:
	state_machine._on_state_transition(state_machine.current_state, "EnemyCharge")
