extends Control

@export var game_scene: PackedScene
@export var starting_scene: PackedScene

func _on_button_2_pressed() -> void:
	if game_scene:
		get_tree().change_scene_to_packed(game_scene)
		
func _on_button_pressed() -> void:
	if starting_scene:
		get_tree().change_scene_to_packed(starting_scene)
