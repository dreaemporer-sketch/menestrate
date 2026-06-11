extends "res://scripts/enemy.gd"
var enemy_type = "lightning"
func _ready():

	speed = 220
	health = 3

	resistance = "lightning"
	enemy_type = "lightning"

	super._ready()
