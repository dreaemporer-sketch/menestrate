extends "res://scripts/enemy.gd"
func _ready():

	speed = 50
	health = 100
	damage = 20
	resistance = "fire"

	super._ready()

func take_damage(amount, element = "none"):

	super.take_damage(amount, element)

	if health <= 0:

		var player = get_tree().get_first_node_in_group("player")

		if player:
			player.fire_unlocked = true
