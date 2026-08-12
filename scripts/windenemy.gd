extends "res://scripts/enemy.gd"
var enemy_type =  Constant.ELEMENT_WIND
func _ready():

	speed = 90
	health = 6

	resistance = Constant.ELEMENT_WIND
	enemy_type = Constant.ELEMENT_WIND
	super._ready()
	
