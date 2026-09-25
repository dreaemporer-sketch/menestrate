extends Area2D

@export var speed = Constant.BULLET_SPEED

var direction = Vector2.ZERO
var damage = 1
var element = Constant.ELEMENT_NONE


func _ready():


	await get_tree().create_timer(Constant.BULLET_LIFETIME).timeout

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

func update_bullet_colour():
	match element:
		Constant.ELEMENT_FIRE:
			modulate = Constant.ELEMENT_FIRE_COLOR
			$Sprite2D/AnimatedSprite2D.play("fire")
		Constant.ELEMENT_EARTH:
			modulate = Constant.ELEMENT_EARTH_COLOR
			$Sprite2D/AnimatedSprite2D.play("earth")
		Constant. ELEMENT_WATER:
			modulate = Constant.ELEMENT_WATER_COLOR
			$Sprite2D/AnimatedSprite2D.play("water")
		Constant. ELEMENT_WIND:
			modulate = Constant.ELEMENT_WIND_COLOR
			$Sprite2D/AnimatedSprite2D.play("wind")
		Constant. ELEMENT_LIGHTNING:
			modulate = Constant.ELEMENT_LIGHTNING_COLOR
			$Sprite2D/AnimatedSprite2D.play("lightning")
		Constant. ELEMENT_NONE:
			modulate = Constant.ELEMENT_NONE_COLOR
			$Sprite2D/AnimatedSprite2D.play("default")
	
	 
