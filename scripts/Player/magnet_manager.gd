class_name MagnetManager
extends Node2D

@onready var player: Player = $".."
@onready var push_area: CollisionShape2D = $PushArea/CollisionShape2D

@onready var effects: AnimatedSprite2D = $"../Sprites/Effects"
@onready var breakable_objects: Node = $"../../BreakableObjects"
@onready var magnet_meter: MagnetMeter = $"../../CanvasLayer/MagnetMeter"

var throw_direction: Vector2
var throw_speed := 900.0

var push_force := 550
var attract_speed := 425

var enemies_in_area: Array[EnemyHurtbox]

var current_pulled_object: Crate = null
var held_object: Crate = null
var pull_offset := Vector2(0, 20)

var target_pos: Vector2

# how much of the progress bar does the push spend
var push_meter_value := 0.5

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("push"):
		if (magnet_meter.spend_magnet_meter(push_meter_value)):
			handle_push()

	if Input.is_action_just_pressed("pull"):
		start_object_pull()

	if current_pulled_object and current_pulled_object.is_lifted:
		pull_object(delta)
	
	# throw the object:
	if held_object and Input.is_action_just_pressed("pull"):
		if TargetManager.current_target:
			held_object.throw_direction = (TargetManager.current_target.global_position - held_object.global_position).normalized()
		else:
			held_object.throw_direction = (get_global_mouse_position() - held_object.global_position).normalized()

		held_object.is_being_throwed = true
		held_object = null


# == Push ==
func handle_push() -> void:
	effects.play("push")
	for enemy in enemies_in_area:
		enemy.recieve_push(push_force)

func _on_push_area_area_entered(area: Area2D) -> void:
	if area is EnemyHurtbox:
		enemies_in_area.append(area)

func _on_push_area_area_exited(area: Area2D) -> void:
	if area is EnemyHurtbox:
		enemies_in_area.erase(area)


# == Start attraction only if no crate pulled or held ==
func start_object_pull() -> void:
	if current_pulled_object:
		return

	if held_object:
		return

	var max_attract_distance := 200.0
	var closest_obj: Node2D = null
	var closest_dist := INF

	for child in breakable_objects.get_children():
		if child is Node2D:
			var dist := self.global_position.distance_to(child.global_position)
			if dist < max_attract_distance and dist < closest_dist:
				closest_dist = dist
				closest_obj = child

	if closest_obj:
		current_pulled_object = closest_obj
		# crate lift animation:
		current_pulled_object.lift()


# == Continuous pulling until lock-in ==
func pull_object(delta: float) -> void:
	var obj := current_pulled_object
	if obj == null:
		return
	
	# stop player movement and animation
	player.can_move = false
	player.velocity = Vector2.ZERO
	player.animated_sprite_2d.play("idle_front")

	var target_pos := self.global_position + pull_offset.rotated(self.global_rotation)

	obj.global_position = obj.global_position.move_toward(target_pos, attract_speed * delta)

	if obj.global_position.distance_to(target_pos) < 2.0:
		obj.get_parent().remove_child(obj)
		self.add_child(obj)
		obj.position = pull_offset

		held_object = obj
		
		current_pulled_object = null
		player.can_move = true
		held_object.levitate()

func change_area_positions(dir: String) -> void:
	match dir:
		"right":
			push_area.position = Vector2(68.5, -19.5)
			pull_offset = Vector2(20, -10)
		"left":
			push_area.position = Vector2(-68.5, -19.5)
			pull_offset = Vector2(-40, -10)
		"top":
			push_area.position = Vector2(0, -68.5)
			pull_offset = Vector2(-5, -40)
		"down":
			push_area.position = Vector2(0, 25)
			pull_offset = Vector2(-5, 20)
