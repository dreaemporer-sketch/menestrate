extends "res://scripts/enemy.gd"
var enemy_type = "wind"
func _ready():

	speed = 90
	health = 6

	resistance = "wind"
	enemy_type = "wind"
	super._ready()
	
