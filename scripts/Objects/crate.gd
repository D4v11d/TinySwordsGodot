class_name Crate
extends RigidBody2D

@onready var hurtbox: Breakable = $Hurtbox
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_being_throwed := false
var is_lifted := false
var throw_direction: Vector2 = Vector2.ZERO
var throw_speed := 900.0

func _ready() -> void:
	hurtbox.connect("destroyed", on_destroyed)

func _physics_process(delta: float) -> void:
	if is_being_throwed:
		global_position += throw_direction * throw_speed * delta

func on_destroyed():
	is_being_throwed = false

func lift():
	animation_player.play("lift")

func levitate():
	animation_player.play("levitate")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "lift":
		is_lifted = true
