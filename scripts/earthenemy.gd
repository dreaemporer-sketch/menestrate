extends "res://scripts/enemy.gd"

var enemy_type = "earth"

func _ready():
	speed = 220
	health = 2
	resistance = "earth"
	enemy_type = "earth"
	super._ready()
