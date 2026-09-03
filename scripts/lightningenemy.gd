extends "res://scripts/enemy.gd"
var enemy_type =  Constant.ELEMENT_LIGHTNING
func _ready():

	speed = 220
	health = 30

	resistance = Constant.ELEMENT_LIGHTNING
	enemy_type = Constant.ELEMENT_LIGHTNING

	super._ready()
