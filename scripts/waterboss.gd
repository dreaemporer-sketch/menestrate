extends "res://scripts/enemy.gd"
func _ready():

	speed = 100
	health = 260
	damage = 25
	resistance = Constant.ELEMENT_WATER

	super._ready()

func take_damage(amount, element = Constant.ELEMENT_NONE):

	super.take_damage(amount, element)

	if health <= 0:

		var player = get_tree().get_first_node_in_group("player")

		if player:
			player.water_unlocked = true
