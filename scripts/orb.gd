
extends Area2D

var elements = [
	Constant.ELEMENT_FIRE,
	Constant.ELEMENT_WATER,
	Constant.ELEMENT_EARTH,	
	Constant.ELEMENT_LIGHTNING,
	Constant.ELEMENT_WIND
]
@export var speed = 100.0
var direction = Vector2.RIGHT
var selected_element = Constant.ELEMENT_FIRE


func _ready():

	randomize()

	selected_element = elements.pick_random()

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group(Constant.PLAYER_GROUP):
		body.set_element(selected_element)
		queue_free()
