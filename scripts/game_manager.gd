extends Node
class_name GameManager

@onready var stage_label: Label = $CanvasLayer/StageContainer/StageLabel
@onready var enemies: Node2D = $Enemies
@onready var player: Player = $Player

@onready var pos_1: Marker2D = $EnemySpawnPositions/Pos1
@onready var pos_2: Marker2D = $EnemySpawnPositions/Pos2
@onready var pos_3: Marker2D = $EnemySpawnPositions/Pos3
@onready var finish_game_background: Panel = $CanvasLayer/FinishGameBackground
@onready var death_text: Label = $CanvasLayer/FinishGameBackground/PlayAgainButton/DeathText
@onready var win_text: Label = $CanvasLayer/FinishGameBackground/PlayAgainButton/WinText

@onready var pc_controls: Node2D = $CanvasLayer/ControlsPanel/Controls/PCControls
@onready var joystick_controls: Node2D = $CanvasLayer/ControlsPanel/Controls/JoystickControls
@onready var controls_panel: Panel = $CanvasLayer/ControlsPanel

const ENEMY_DINO_SCENE: PackedScene = preload("res://scenes/enemy_dino.tscn")

const STAGE_TRANSITION_DELAY := 0.75
const STAGE_START_DELAY := 0.5

var current_stage: int = 1
var spawn_points: Array[Marker2D]
var stages: Array[int] = [1, 2, 3] # Number of enemies per stage

var is_restarting: bool = false
var last_stage_cleared = false
var game_started = false

func _ready() -> void:
	get_tree().paused = true
	controls_panel.visible = true
	spawn_points = [pos_1, pos_2, pos_3]
	TargetManager.connect("all_enemies_cleared", Callable(self, "on_all_enemies_cleared"))

	player.connect("show_death_menu", handle_show_death_menu)

func start_game():
	get_tree().paused = false
	start_stage(1)
	controls_panel.visible = false
	game_started = true
	

func on_all_enemies_cleared() -> void:
	if is_restarting:
		return
		
	await get_tree().create_timer(STAGE_TRANSITION_DELAY).timeout
	start_next_stage()


func start_next_stage() -> void:
	current_stage += 1
	
	if current_stage > stages.size():
		last_stage_cleared = true
		handle_show_win_menu()
		return
	
	start_stage(current_stage)


func start_stage(stage_number: int) -> void:
	current_stage = stage_number
	stage_label.show_stage(current_stage)
	clear_enemies()
	
	await get_tree().create_timer(STAGE_START_DELAY).timeout
	spawn_stage_enemies(stages[stage_number - 1])


func spawn_stage_enemies(enemy_count: int) -> void:
	for i in enemy_count:
		spawn_enemy(spawn_points[i].position)


func clear_enemies() -> void:
	for child in enemies.get_children():
		child.queue_free()


func spawn_enemy(position: Vector2) -> void:
	var enemy_instance: Node2D = ENEMY_DINO_SCENE.instantiate()
	enemy_instance.position = position
	enemies.add_child(enemy_instance)

func _input(event):
	if event.is_action_pressed("select") and finish_game_background.visible:
		_on_play_again_button_button_down()
	
func handle_show_death_menu():
	win_text.visible = false
	death_text.visible = true
	finish_game_background.visible = true

func handle_show_win_menu():
	win_text.visible = true
	death_text.visible = false
	finish_game_background.visible = true
	

func play_again() -> void:
	is_restarting = true
	finish_game_background.visible = false
	
	await start_stage(current_stage)
	player.respawn()
	
	is_restarting = false

func _on_play_again_button_button_down() -> void:
	if last_stage_cleared:
		current_stage = 1
		last_stage_cleared = false

	play_again()

func select_PC_controls():
	joystick_controls.visible = false
	pc_controls.visible = true

func select_joystick_controls():
	joystick_controls.visible = true
	pc_controls.visible = false
