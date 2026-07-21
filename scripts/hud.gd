extends CanvasLayer

@export var player: Node
@export var panel: Control 
@export var time_label: Label
@export var weapon_label: Label
@export var element_label: Label
@export var round_label: Label
@export var health_label: Label
@export var continue_label: Label
@export var stamina_label: Label
@export var kills_label: Label

func _process(_delta):
	if player == null:
		return

	time_label.text = "needed kills: " + str(player.enemies_killed_this_round) + "/" + str(player.enemies_to_kill)
	weapon_label.text = "Weapon: " + player.current_weapon
	element_label.text = "Element: " + player.current_element
	round_label.text = "Round: " + str(player.current_round)
	health_label.text = "Health: " + str(player.health)
	stamina_label.text = "Stamina: " + str(player.stamina)
	kills_label.text = "Kills: " + str(player.kills)
	continue_label.text = "Continues: " + str(player.continues_left)

func _ready():
	panel.visible = false
func _on_button_pressed():
	panel.visible = !panel.visible
	
