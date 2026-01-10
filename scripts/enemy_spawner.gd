# File: res://scripts/enemy_spawner.gd
extends Node

@onready var area_2d: Area2D = $Area2D
@onready var spawn_timer: Timer = $SpawnTimer
@onready var enemy_dino_scene: PackedScene = preload("res://scenes/enemy_dino.tscn")
@onready var enemies_container: Node2D = $"../Enemies"

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()
	print("enemy spawner ready")


func _on_spawn_timer_timeout() -> void:
	if not enemies_container:
		push_warning("Enemies container not found.")
		return

	var enemy_instance = enemy_dino_scene.instantiate()
	enemy_instance.global_position = _get_random_point_in_circle()
	enemies_container.add_child(enemy_instance)


func _get_random_point_in_circle() -> Vector2:
	var shape: CollisionShape2D = area_2d.get_node("CollisionShape2D")
	if not shape or not shape.shape is CircleShape2D:
		push_warning("Area2D must have a CircleShape2D.")
		return area_2d.global_position

	var radius: float = shape.shape.radius
	var angle: float = randf() * TAU
	var dist: float = sqrt(randf()) * radius
	var local_pos = Vector2(cos(angle), sin(angle)) * dist
	return area_2d.to_global(local_pos)
