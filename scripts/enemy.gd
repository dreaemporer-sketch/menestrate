

extends CharacterBody2D

@export var speed = 100

@export var health = 3

@export var damage = 10

var player

var resistance = "none"


func _ready():

	player = get_tree().get_first_node_in_group(
		"player"
	)


func _physics_process(delta):

	if player != null:

		var direction = (
			player.global_position - global_position
		).normalized()

		velocity = direction * speed

		move_and_slide()


func take_damage(amount, element = "none"):
	if element == resistance:
		amount *= 0.3 # resistant

	elif element == "water" and resistance == "fire":
		amount *= 2 # weakness

	elif element == "fire" and resistance == "earth":
		amount *= 2

	elif element == "earth" and resistance == "lightning":
		amount *= 2

	elif element == "lightning" and resistance == "water":
		amount *= 2

	elif element == "wind" and resistance == "earth":
		amount *= 2


	health -= amount


	if health <= 0:

		if player != null:
			player.kills += 1

		queue_free()

func _on_area_2d_body_entered(body):

	if body.is_in_group("player"):

		body.take_damage(damage)

		queue_free()
