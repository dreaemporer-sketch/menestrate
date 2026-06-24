extends "res://scripts/enemy.gd"
func _ready():

	speed = 60
	health = 140
	damage = 25
	resistance = "water"

	super._ready()

func take_damage(amount, element = "none"):

	super.take_damage(amount, element)

	if health <= 0:

		var player = get_tree().get_first_node_in_group("player")

		if player:
			player.water_unlocked = true
