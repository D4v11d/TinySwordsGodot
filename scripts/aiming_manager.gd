class_name EnemyAimingManager extends Node2D

@onready var enemy_array: Array[Enemy] = []
@onready var enemy: Enemy = $"../../Enemies/Enemy"

var locked_target: bool = false

func _ready() -> void:
	enemy_array.append(enemy)

func _physics_process(delta: float) -> void:
	
	if enemy == null:
		return
		
	locked_target = enemy.target.visible
	
	if locked_target:
		CameraPosition.lock_on_target(enemy.global_position)
	
	if Input.is_action_just_pressed("Lock"):
		var enemy = enemy_array[0]
		enemy.toggle_target()
		
		
		if not enemy.target.visible:
			CameraPosition.remove_target_lock()
