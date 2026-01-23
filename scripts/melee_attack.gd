class_name MeleeAttack extends Node2D

@onready var state_machine: StateMachine = $"../../StateMachine"

# Parry
@onready var parry_area: Area2D = $"../Parry/ParryArea"
@onready var parry_timer: Timer = $"../Parry/ParryTimer"
@onready var parry_sound: AudioStreamPlayer2D = $"../Parry/ParrySound"

# Pending: set a cooldown after combo finish to attack again
var is_attack_ready := true
var is_parry_activated := false

var enemy_in_area: EnemyHurtbox

func _ready():
	pass

func _physics_process(_delta: float) -> void:
	var current_state = state_machine.current_state
	
	var can_enter_attack = current_state is not PlayerAttack and current_state is not PlayerStagger
	# enters attack state for the first time
	if can_enter_attack and Input.is_action_just_pressed("attack") and is_attack_ready:
		state_machine._on_state_transition(state_machine.current_state, "PlayerAttack")
	
	if can_enter_attack and Input.is_action_just_pressed("parry"):
		handleActivateParry()
	
	if is_parry_activated and enemy_in_area:
		enemy_in_area.handle_parry_stagger()
	

func handleActivateParry() -> void:
	is_parry_activated = true
	parry_timer.start()

func _on_parry_area_area_entered(enemy: Area2D) -> void:
	if enemy is EnemyHurtbox:
		enemy_in_area = enemy

func _on_parry_area_area_exited(_area: Area2D) -> void:
	enemy_in_area = null

func _on_parry_timer_timeout() -> void:
	is_parry_activated = false
