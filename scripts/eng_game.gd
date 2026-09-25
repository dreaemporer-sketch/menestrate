extends Control
@export var game_scene: PackedScene
@export var starting_scene: PackedScene
var retries_used: int = Constant.INITIAL_RETRIES


func _on_button_2_pressed() -> void:
	if retries_used < Constant.MAX_RETRY:
		retries_used +=1
		get_tree().change_scene_to_packed(game_scene)
		print(retries_used)
	else:
		_start_new_game()
		
func _on_button_pressed() -> void:
	if starting_scene:
		get_tree().change_scene_to_packed(starting_scene)

func _start_new_game() -> void:
	if starting_scene:
		get_tree().change_scene_to_packed(starting_scene)
