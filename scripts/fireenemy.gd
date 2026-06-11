extends "res://scripts/enemy.gd"
var enemy_type = "fire"
func _ready():

	speed = 100
	health = 6

	resistance = "fire"
	enemy_type = "fire"

	super._ready()
