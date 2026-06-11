extends Control


func _on_play_pressed():

	# Deletes old save
	DirAccess.remove_absolute(
		"user://save.save"
	)

	get_tree().change_scene_to_file(
		"res://Game.tscn"
	)


func _on_continue_pressed():

	if FileAccess.file_exists(
		"user://save.save"
	):

		get_tree().change_scene_to_file(
			"res://Game.tscn"
		)


func _on_quit_pressed():

	get_tree().quit()
