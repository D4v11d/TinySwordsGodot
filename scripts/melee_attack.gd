class_name MeleeAttack extends Node2D

@onready var state_machine: StateMachine = $"../StateMachine"

func _ready():
	pass

func _physics_process(delta: float) -> void:
	var current_state = state_machine.current_state
	
	# enters attack state for the first time
	if current_state is not PlayerAttack and Input.is_action_just_pressed("attack"):
		state_machine._on_state_transition(state_machine.current_state, "PlayerAttack")
