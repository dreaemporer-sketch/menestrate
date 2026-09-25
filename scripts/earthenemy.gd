extends "res://scripts/enemy.gd"

var enemy_type =  Constant.ELEMENT_EARTH

func _ready():
	speed = 250
	health = 30
	resistance = Constant.ELEMENT_EARTH
	enemy_type = Constant.ELEMENT_EARTH
	super._ready()
