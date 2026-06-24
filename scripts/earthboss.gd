extends "res://scripts/enemy.gd"
func _ready():

	speed = 40
	health = 250
	damage = 35
	resistance = "earth"

	super._ready()

func take_damage(amount, element = "none"):

	super.take_damage(amount, element)

	if health <= 0:

		var player = get_tree().get_first_node_in_group("player")

		if player:
			player.earth_unlocked = true
