extends CharacterBody2D

@export var speed = 100
@export var max_health: float = 3.0
@export var health:float = 3
var health_pct: float = 1.0
@export var damage = 10
var player
var resistance = Constant.ELEMENT_NONE
var player_in_range = false
var damage_timer = 0.0

func _ready():
	player = get_tree().get_first_node_in_group("player")
	update_health_visuals()
	
func _physics_process(delta):

	if player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

	if player_in_range and player != null:
		damage_timer -= delta
		if damage_timer <= 0:
			player.take_damage(damage)
			damage_timer = 3.0 
		
func take_damage(amount, element = Constant.ELEMENT_NONE):
	if element == resistance:
		amount *= 0.3

	elif element == Constant.ELEMENT_WATER and resistance == Constant.ELEMENT_FIRE:
		amount *= 2 

	elif element == Constant.ELEMENT_FIRE and resistance == Constant.ELEMENT_EARTH:
		amount *= 2

	elif element == Constant.ELEMENT_EARTH and resistance ==Constant.ELEMENT_LIGHTNING:
		amount *= 2

	elif element == Constant.ELEMENT_LIGHTNING and resistance == Constant.ELEMENT_WATER:
		amount *= 2

	elif element == Constant.ELEMENT_WIND and resistance == Constant.ELEMENT_EARTH:
		amount *= 2
	health -= amount
	update_health_visuals()

	if health <= 0:

		if player != null:
			player.kills += 1
			player.enemy_killed()
		queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group(Constant.PLAYER_GROUP):
		if not player_in_range:
			player_in_range = true
			player = body
			body.take_damage(damage)
			damage_timer = Constant.DAMAGE_INTERVAL
		
func update_health_visuals():
	health_pct = health / max_health
	$sprite2d.modulate = Color(1.0, health_pct, health_pct, 1.0)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		damage_timer = 0.0 # Clear the timer when they leave
