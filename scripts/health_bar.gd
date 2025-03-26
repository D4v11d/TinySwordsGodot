class_name Health extends ProgressBar

var max_health := 0.0
var current_health := 0.0

@onready var character: GameCharacter = $".."

func _ready() -> void:
	max_health = max_value
	current_health = max_value
	update_progress_bar()
	
func recieve_damage(damage: int) -> void:
	print("recieved damage")
	current_health = clamp(current_health - damage, 0, max_health)
	update_progress_bar()
	verify_death()
	
func update_progress_bar() -> void:
	value = current_health


func verify_death() -> void:
	if current_health <= 0:
		character.queue_free()
