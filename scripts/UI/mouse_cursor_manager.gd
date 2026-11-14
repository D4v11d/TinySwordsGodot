extends Node2D

var mouse_visible := true

func _input(event):

	# If joystick is used
	if event is InputEventJoypadMotion or event is InputEventJoypadButton:
		hide_mouse()

	# If mouse moves or clicks
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		show_mouse()

func hide_mouse():
	if mouse_visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		mouse_visible = false

func show_mouse():
	if not mouse_visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouse_visible = true
