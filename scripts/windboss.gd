extends "res://scripts/enemy.gd"
func _ready():

	speed = 70
	health = 120
	damage = 20
	resistance = "wind"

	super._ready()

func take_damage(amount, element = "none"):

	super.take_damage(amount, element)

	if health <= 0:

		var player = get_tree().get_first_node_in_group("player")

		if player:
			player.wind_unlocked = true
