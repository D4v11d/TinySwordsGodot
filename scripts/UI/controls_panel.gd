extends Panel

@onready var controls_panel: Panel = $"."
@onready var play_button: Button = $Play
@onready var game: GameManager = $"../.."
@onready var exit: Button = $Exit

func _input(event):
	if event.is_action_pressed("pause"):
		if game.game_started:
			toggle_pause_menu()
		else:
			game.start_game()

func toggle_pause_menu():
	play_button.visible = false
	exit.visible = true
	
	var paused := !get_tree().paused
	get_tree().paused = paused
	controls_panel.visible = paused

func exit_game():
	get_tree().quit()
