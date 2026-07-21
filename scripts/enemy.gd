extends CharacterBody2D

@export var speed = 100
@export var max_health: float = 3.0
@export var health:float = 3
var health_pct: float = 1.0
@export var damage = 10
var player
var resistance = "none"
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

	if player_in_range:
		damage_timer-=delta
		if damage_timer <=0:
			player.take_damage()
			damage_timer=3
		
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
	update_health_visuals()

	if health <= 0:

		if player != null:
			player.kills += 1
			player.enemy_killed()
		queue_free()

func _on_area_2d_body_entered(body):

	if body.is_in_group("player"):
		player_in_range=true
		player=body
		body.take_damage(damage)
		damage_timer=3.0
		
func update_health_visuals():
	health_pct = health / max_health
	if has_node("Sprite2D"):
		$Sprite2D.modulate = Color(1.0, health_pct, health_pct, 1.0)
	else:
		push_error(name + " does NOT have a direct child called Sprite2D")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range=false
