extends Node

@export var total_health: int

@onready var h_box_container: HBoxContainer = $ResizableBackground/HBoxContainer
@onready var resizable_background: NinePatchRect = $ResizableBackground


func _ready() -> void:
	resizable_background.size.x = 15


func _process(delta: float) -> void:
	pass
