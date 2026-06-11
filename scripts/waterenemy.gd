extends "res://scripts/enemy.gd"
var enemy_type = "water"
func _ready():

	speed = 90
	health = 6

	resistance = "water"
	enemy_type = "water"
	super._ready()
