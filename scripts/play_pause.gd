extends Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		print("GAME PAUSED SUCCESSFULLY")

	if Input.is_action_just_pressed("play"):
		get_tree().paused = false
		print("GAME RESUMED SUCCESSFULLY")
