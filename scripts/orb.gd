# =========================
# orb.gd
# =========================

extends Area2D

var elements = [
	"fire",
	"water",
	"earth",
	"lightning",
	"wind"
]

var selected_element = "fire"


func _ready():

	randomize()

	selected_element = elements.pick_random()


func _on_body_entered(body):

	if body.is_in_group("player"):

		body.set_element(selected_element)

		queue_free()
