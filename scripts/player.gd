class_name Player extends GameCharacter

#Grappling hook:
var is_hooked: bool = false

# Fake Z-axis jump variables
var is_falling := false
var z_position := 0.0
var z_velocity := 0.0
const GRAVITY := 2200.0  # gravity acceleration
const JUMP_FORCE := -600.0  # initial jump force

var should_collide := false

var player_direction := Vector2()
var last_direction := Vector2()

var knockback_direction := Vector2()
var can_move := true
 
var is_jumping : bool = false:
	set(value):
		is_jumping = value
		if value == true:
			%state.text = "air"
		else:
			%state.text = "land"
 
var floor : int = 0:
	set(value):
		floor = value
		%floor.text = "Floor (colliding with tile): " + str(value)
 
var height : int = 0:
	set(value):
		height = value
		z_index = value
		%height.text = "Current height: " + str(value)
 
var z_pos: float = 0:
	set(value):
		z_pos = value
		%zpos.text = str("%.2f" % value)

var current_elevation: int = 0:
	set(value):
		current_elevation = value
		%elevation.text = str("Current elevation:" + str(value))


@export var tilemaps: Array[TileMapLayer] = []
@export var grapple_point: GrapplePoint

@onready var next_grapple_point: AnimatableBody2D = $""
@onready var respawn_position: Marker2D = $"../RespawnPosition"

#@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
#@onready var animated_sprite_2d: AnimatedSprite2D = $RobotSprite
@onready var animated_sprite_2d: AnimatedSprite2D = $Sprites/TestSprite

@onready var attack_area: Area2D = $AttackArea
@onready var attack_charge_timer: Timer = $AttackChargeTimer
@onready var player_shadow: CharacterBody2D = $PlayerShadow

@onready var camera: Camera2D = $Camera2D

@onready var layer_switch_manager: LayerSwitchManager = $"../LayerSwitchManager"

@onready var melee_attack_manager: MeleeAttack = $MeleeAttack
@onready var state_machine: StateMachine = $StateMachine

@onready var hitstop: Hitstop = $Hitstop

# Offsets for skipping walls when falling & climbing
# Instead of offsets we should look for the closest floor tile
# For now it's working

const MAX_Z_POSITION = 0
const SHADOW_OFFSET_Y := 25
const SHADOW_MOVE_STEP := 12

func _ready() -> void:
	
	camera.position = Vector2()
	
	# Game character variables
	speed = 300.0
	entity_type = "player"
	attack_damage = 30
	health = $Health

func _physics_process(delta: float) -> void:
	if is_hooked:
		# potentially add a hooked animation
		return
		
	handle_movement(delta)
	handle_jump_physics(delta)
	
	# heightmap code:
	update_tile()
	z_pos = position.y
	var shadow_border_position = player_shadow.global_position
	layer_switch_manager.get_elevation_at_position(shadow_border_position)
	

	if(layer_switch_manager.is_currently_over_wall(shadow_border_position)):
		# falling
		if last_direction == Vector2.DOWN:
			player_shadow.position.y += SHADOW_MOVE_STEP # -> shadow moves down
		# climbing
		else: #includes vertical movement
			player_shadow.position.y -= SHADOW_MOVE_STEP # -> shadow moves up
		is_falling = true

	if Input.is_action_just_pressed("jump"):
		handle_jump()

func update_tile():
	
	check_current_floor()
	
	var tilemap_index = tilemaps.size() - 1
	var map = null;
	var tiledata = null
	
	while !tiledata and tilemap_index >= 0:
		map = tilemaps[tilemap_index];
		tiledata = map.get_cell_tile_data(map.local_to_map(player_shadow.global_position))
		tilemap_index -= 1

	if tiledata:
		floor = tiledata.get_custom_data("height")
		
		if current_elevation > floor:
			if !is_falling:
				player_shadow.position.y += 50 * (current_elevation - floor) # -> shadow moves down
				is_falling = true
		
				# when changing layer in direction UP, it's a different case 
				if last_direction == Vector2.UP: 
					height -= 1
					if is_jumping:
						player_shadow.position.y -= 40 * (current_elevation - floor)
		elif current_elevation == height:
			map = tilemaps[0];
			tiledata = map.get_cell_tile_data(map.local_to_map(player_shadow.global_position))
			if tiledata and tiledata.get_custom_data("is_water"):
				global_position = respawn_position.global_position

func check_current_floor():
	if !is_jumping and !is_falling:
		if floor < height:
			height = floor
			
		current_elevation = height

func handle_water_tile(tiledata):
	CameraPosition.remove_target_lock()
	global_position = respawn_position.position
	

func handle_movement(delta: float) -> void:
	
	move_and_slide()
	
	# Handle attack area flipping for side movement
	if abs(velocity.x) > 0:
		attack_area.scale.x = 1 if velocity.x > 0 else -1
		
	if not can_move:
		return
		
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	player_direction = input_direction

	if player_direction != Vector2.ZERO:
		last_direction = player_direction
		velocity = input_direction.normalized() * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)

	


func handle_jump() -> void:
	
	if is_jumping or is_falling:
		return

	height += 1
	is_jumping = true
	z_velocity = JUMP_FORCE
	z_position = 0.0
	if not melee_attack_manager.is_attacking:
		animated_sprite_2d.play("jump")

func handle_jump_physics(delta: float) -> void:
	var shadow_pos = player_shadow.global_position + Vector2(0, SHADOW_OFFSET_Y)
	
	if is_jumping or is_falling:
		z_velocity += GRAVITY * delta
		z_position += z_velocity * delta
		print("z_velocity: ", z_velocity)
		
		if z_velocity >= 0 and not is_falling:
			# start falling
			is_falling = true
			if not melee_attack_manager.is_attacking:
				animated_sprite_2d.play("fall")
			

		# Apply jump vertical offset
		global_position.y += z_velocity * delta
		# Counteract movement for shadow to keep it grounded
		player_shadow.position.y -= z_velocity * delta
		camera.position.y -= z_velocity * delta

		# Stop jump when player aligns with shadow Y (ground level)
		# on_land()
		var landing_y := player_shadow.global_position.y
		if global_position.y >= landing_y:
			print("player landed")
			z_position = 0.0
			z_velocity = 0.0
			is_jumping = false
			is_falling = false
			global_position.y = landing_y  # Snap to ground
			player_shadow.position.y = 0   # Reset shadow offset
			camera.position.y = 0

func recieve_damage(damage_source: CharacterBody2D):
	knockback_direction = global_position - damage_source.global_position
	state_machine._on_state_transition(state_machine.current_state, "PlayerStagger")
	hitstop.freeze_frame(0.08, 0.25)
