class_name LayerSwitchManager extends Node2D

@onready var player: Player = $"../Player"

@onready var elevation_0: TilemapLayerManager = $"../Map/Elevation0/Tilemap"
@onready var elevation_1: TilemapLayerManager = $"../Map/Elevation1/Tilemap"
@onready var elevation_2: TilemapLayerManager = $"../Map/Elevation2/Tilemap"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_elevation_at_position(_pos: Vector2) -> void:	
	if player.height >= 2:
		elevation_1.disable_layer_collisions()
		elevation_2.disable_layer_collisions()
	elif player.height >= 1:
		elevation_2.enable_layer_collisions()
		elevation_1.disable_layer_collisions()
	elif player.height >= 0:
		elevation_1.enable_layer_collisions()
		elevation_2.enable_layer_collisions()

func is_currently_over_wall(pos: Vector2) -> bool:
	var is_wall = false
	var tiledata = elevation_2.get_cell_tile_data(elevation_2.local_to_map(pos))
		
	if tiledata:
		is_wall = tiledata.get_custom_data("is_wall") #and player.current_elevation >= 2
	else:
		tiledata = elevation_1.get_cell_tile_data(elevation_1.local_to_map(pos))
		if tiledata:
			is_wall = tiledata.get_custom_data("is_wall") #and player.current_elevation >= 1
	
	return is_wall;


func is_currently_on_water(pos: Vector2) -> bool:
	var tiledata = elevation_0.get_cell_tile_data(elevation_0.local_to_map(pos))
	var is_water = false
	
	if tiledata:
		is_water = tiledata.get_custom_data("is_water")
	
	return is_water

#func is_wall_blocking_jump(pos: Vector2) -> bool:
	#var elevation_at_pos = null
	#var tiledata = elevation_2.get_cell_tile_data(elevation_2.local_to_map(pos))
		#
	#if tiledata:
		#if(tiledata.get_custom_data("is_wall")): #and player.current_elevation >= 2
			#elevation_at_pos = 2
	#else:
		#tiledata = elevation_1.get_cell_tile_data(elevation_1.local_to_map(pos))
		#if tiledata:
			#if(tiledata.get_custom_data("is_wall")): #and player.current_elevation >= 1
				#elevation_at_pos = 1
	#
	#if elevation_at_pos == null:
		#return false
	#
	## Block only if wall elevation is > current + 1
	#return elevation_at_pos > player.current_elevation + 1
