class_name ShootingManager extends Node2D

@onready var state_machine: StateMachine = $"../StateMachine"

func _physics_process(delta: float) -> void:

	var current_state := state_machine.current_state
	if current_state == null:
		return

	if Input.is_action_pressed("shoot"):
		if not current_state.can_shoot():
			return
		
		state_machine._on_state_transition(current_state, "PlayerShoot")
