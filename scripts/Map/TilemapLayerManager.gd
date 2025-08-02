class_name TilemapLayerManager extends TileMapLayer

func disable_layer_collisions() -> void:
	self.collision_enabled = false

func enable_layer_collisions() -> void:
	self.collision_enabled = true
