extends Control

@export var starting_scene : PackedScene

func _on_button_pressed() -> void:
	if starting_scene:
		get_tree().change_scene_to_packed(starting_scene)
func _on_button_2_pressed() -> void:
		get_tree().change_scene_to_file("res://scenes/settings.tscn")
		

func _on_pressed() -> void:
	pass 
