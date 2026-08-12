extends "res://scripts/enemy.gd"
var enemy_type =  Constant.ELEMENT_WATER
func _ready():

	speed = 90
	health = 6

	resistance = Constant.ELEMENT_WATER
	enemy_type = Constant.ELEMENT_WATER
	super._ready()
