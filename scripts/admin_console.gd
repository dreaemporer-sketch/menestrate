extends CanvasLayer

@onready var player = get_tree().get_first_node_in_group("player")
@export var panel: Panel
@export var line_edit: LineEdit
var console_open = false
func _ready():
	panel.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("admin_console"):
		console_open = !console_open
		panel.visible = console_open

		if console_open:
			line_edit.grab_focus()
		else:
			line_edit.release_focus()
func _on_line_edit_text_submitted(command:String)-> void:
	print("Command:")
	var parts = command.split(" ")
	

	if parts.size() == 0:
		return

	match parts[0].to_lower():

		"round":
			if parts.size() >= 2:
				player.current_round = int(parts[1])
				player.enemies_to_kill = player.current_round * Constant.ENEMY_PER_ROUNDdd
				player.enemies_killed_this_round = 0
				player.enemies_spawned_this_round = 0
				player.boss_spawned = false
				var total_kills = 0
				for i in range(1, player.current_round):
					total_kills += i * 5
				player.kills = total_kills

		"health":
			if parts.size() >= 2 and parts[1].is_valid_int():
				player.health = int(parts[1])

		"kills":
			if parts.size() >= 2:
				player.kills = int(parts[1])

		"weapon":
			if parts.size() >= 2:
				player.current_weapon = parts[1]
				player.update_weapon()

		"element":
			if parts.size() >= 2:
				player.set_element(parts[1])

		"continues":
			if parts.size() >= 2:
				player.continues_left = int(parts[1])

		"speed":
			if parts.size() >= 2:
				player.speed = int(parts[1])

	line_edit.text = ""
	panel.visible = false
	console_open = false
