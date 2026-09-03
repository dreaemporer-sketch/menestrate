extends "res://scripts/enemy.gd"
var enemy_type =  Constant.ELEMENT_FIRE
func _ready():

	speed = 100
	health = 30

	resistance = Constant.ELEMENT_FIRE
	enemy_type = Constant.ELEMENT_FIRE

	super._ready()
