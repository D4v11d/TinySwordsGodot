extends Panel

@onready var controls_panel: Panel = $"."
@onready var play_button: Button = $Play
@onready var game: GameManager = $"../.."

func _input(event):
	if event.is_action_pressed("pause") and game.game_started:
		toggle_pause_menu()

func toggle_pause_menu():
	play_button.visible = false
	var paused := !get_tree().paused
	get_tree().paused = paused
	controls_panel.visible = paused
