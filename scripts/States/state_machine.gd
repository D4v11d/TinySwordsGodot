extends Node
class_name StateMachine

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	for state in get_children():
		if state is State:
			states[state.name] = state
			state.Transitioned.connect(_on_state_transition)

func _process(delta: float) -> void:
	if current_state:
		current_state.update()

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update()

func _on_state_transition():
	pass
	
	# pending
