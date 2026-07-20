extends Control

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings.tscn")
	print("pressed")


func _on_pressed() -> void:
	pass # Replace with function body.
