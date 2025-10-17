extends Node
class_name StateMachine

var current_state: State
var states: Dictionary = {}

@export var initial_state : State

func _ready() -> void:
	for state in get_children():
		if state is State:
			states[state.name.to_lower()] = state
			state.Transitioned.connect(_on_state_transition)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _on_state_transition(state: State, new_state_name: String):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower()) as State
	if !new_state:
		return
		
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
