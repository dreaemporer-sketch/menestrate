extends "res://scripts/enemy.gd"
func _ready():

	speed = 300
	health = 250
	damage = 35
	resistance = Constant.ELEMENT_EARTH

	super._ready()

func take_damage(amount, element = Constant.ELEMENT_NONE):

	super.take_damage(amount, element)

	if health <= 0:

		var player = get_tree().get_first_node_in_group("player")

		if player:
			player.earth_unlocked = true
