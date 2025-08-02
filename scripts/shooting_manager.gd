class_name ShootingManager extends Node2D

@onready var player: Player = $".."
@onready var enemy_aiming_manager: EnemyAimingManager = $"../EnemyAimingManager"
@onready var destroy_timer: Timer = $DestroyTimer

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		print("shoot just pressed")
		var enemy = enemy_aiming_manager.enemy
		var enemy_position = Vector2.ZERO
		if enemy != null:
			print("there is enemy")
			enemy_position = enemy.global_position
			
		print("bullet instantiated")
		var bullet = preload("res://scenes/bullet.tscn").instantiate()
		bullet.global_position = player.global_position
		get_node("../..").add_child(bullet)
		bullet.shoot(enemy_position)
