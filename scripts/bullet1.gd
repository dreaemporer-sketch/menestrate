
extends Area2D

@export var speed = 800

var direction = Vector2.ZERO
var damage = 1
var element = "none"


func _ready():

	body_entered.connect(
		_on_body_entered
	)

	await get_tree().create_timer(3.0).timeout

	queue_free()


func _physics_process(delta):

	global_position += (
		direction * speed * delta
	)


func _on_body_entered(body):

	# IGNORE PLAYER

	if body.is_in_group("player"):

		return

	# DAMAGE ENEMIES

	if body.has_method("take_damage"):

		body.take_damage(damage, element)

	queue_free()
