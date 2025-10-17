class_name MeleeAttack extends Node2D

@onready var state_machine: StateMachine = $"../StateMachine"

var is_attacking := false

func _ready():
	pass

func _physics_process(delta: float) -> void:
	if !is_attacking and Input.is_action_just_pressed("attack"):
		is_attacking = true
		state_machine._on_state_transition(state_machine.current_state, "PlayerAttack")
