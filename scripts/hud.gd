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
@export var element_timer_label: Label
var time_survived: int =0

func _process(_delta):
	if player == null:
		return
	if player.current_element != Constant.ELEMENT_NONE:
		element_timer_label.visible = true
		element_timer_label.text = player.current_element
	else:
		element_timer_label.visible = false

	
	weapon_label.text = "Weapon: " + player.current_weapon
	element_label.text = "Element: " + player.current_element
	round_label.text = "Round: " + str(player.current_round)
	health_label.text = "Health: " + str(player.health)
	stamina_label.text = "Stamina: " + str(round(player.stamina))
	kills_label.text = "Kills: " + str(player.kills) + "| Needed:" + str(player.enemies_killed_this_round) + "/" + str(player.enemies_to_kill)
	continue_label.text = "Continues: " + str(player.continues_left)

func _ready():
	panel.visible = false
	player = get_tree().get_first_node_in_group("player")
	$survival_timer.timeout.connect(_on_survival_timer_timeout)
func _on_button_pressed():
	panel.visible = !panel.visible
func _on_survival_timer_timeout():
	time_survived +=1 
	var minutes = time_survived/60
	var seconds = time_survived % 60
	time_label.text = "time:%02d:%02d" % [minutes,seconds]
