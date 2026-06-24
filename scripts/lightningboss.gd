extends "res://scripts/enemy.gd"
func _ready():

	speed = 100
	health = 160
	damage = 30
	resistance = "lightning"

	super._ready()

func take_damage(amount, element = "none"):

	super.take_damage(amount, element)

	if health <= 0:

		var player = get_tree().get_first_node_in_group("player")

		if player:
			player.lightning_unlocked = true
