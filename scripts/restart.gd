extends Node

func _process(delta):
	if Input.is_key_pressed(KEY_SHIFT) and Input.is_action_just_pressed("restart"):
		DirAccess.remove_absolute("user://save.save")
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	elif Input.is_action_just_pressed("restart_round"):
		get_tree().reload_current_scene()
