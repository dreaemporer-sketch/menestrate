extends "res://scripts/enemy.gd"
func _ready():

	speed = 70
	health = 220
	damage = 20
	resistance = Constant.ELEMENT_WIND

	super._ready()

func take_damage(amount, element = Constant.ELEMENT_NONE):

	super.take_damage(amount, element)

	if health <= 0:

		var player = get_tree().get_first_node_in_group("player")

		if player:
			player.wind_unlocked = true
