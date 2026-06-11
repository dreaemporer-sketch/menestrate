# =========================
# player.gd
# =========================

extends CharacterBody2D

@export var speed = 250
@export var bullet_scene: PackedScene

# BULLET DAMAGE
var bullet_damage = 1

# ENEMIES
@export var fast_enemy_scene: PackedScene
@export var tank_enemy_scene: PackedScene
@export var fire_enemy_scene: PackedScene
@export var water_enemy_scene: PackedScene
@export var earth_enemy_scene: PackedScene
@export var lightning_enemy_scene: PackedScene
@export var wind_enemy_scene: PackedScene

# ORB
@export var orb_scene: PackedScene

# SPAWN PATHS
@export var enemy_spawn: PathFollow2D
@export var orb_spawn: PathFollow2D

# UI LABELS
@export var time_label: Label
@export var weapon_label: Label
@export var element_label: Label
@export var round_label: Label
@export var health_label: Label
@export var continue_label: Label
@export var stamina_label: Label
@export var kills_label: Label 

# PLAYER STATS
var health = 100
var stamina = 100

var continues_left = 10

# WEAPON
var current_weapon = "glock"

var fire_rate = 0.4

var shoot_timer = 0.0

# ELEMENT
var current_element = "none"

var element_timer = 0.0

var element_duration = 120.0

# ROUND SYSTEM
var survive_time = 0.0

var current_round = 1

# SPAWN TIMERS
var enemy_spawn_timer = 0.0

var orb_spawned_this_round = false

# PAUSE
var paused_game = false


func _ready():

	randomize()

	add_to_group("player")

	load_game()


func _physics_process(delta):

	# =====================
	# PAUSE
	# =====================

	if Input.is_action_just_pressed("pause"):

		paused_game = !paused_game

		get_tree().paused = paused_game

	# =====================
	# MOVEMENT
	# =====================

	var direction = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	velocity = direction * speed

	move_and_slide()

	# LOOK AT MOUSE

	look_at(get_global_mouse_position())

	# =====================
	# SHOOT TIMER
	# =====================

	shoot_timer -= delta

	# =====================
	# SHOOTING
	# =====================

	if Input.is_action_pressed("shoot"):

		if shoot_timer <= 0:

			shoot()

			shoot_timer = fire_rate

	# =====================
	# WEAPON SWITCHING
	# =====================

	if Input.is_action_just_pressed("weapon_1"):

		current_weapon = "glock"

		update_weapon()

	if Input.is_action_just_pressed("weapon_2"):

		current_weapon = "rifle"

		update_weapon()

	if Input.is_action_just_pressed("weapon_3"):

		current_weapon = "machine"

		update_weapon()

	if Input.is_action_just_pressed("weapon_4"):

		current_weapon = "shotgun"

		update_weapon()

	# =====================
	# ROUND TIMER
	# =====================

	survive_time += delta

	if survive_time >= 300:

		current_round += 1

		survive_time = 0

		orb_spawned_this_round = false

	# =====================
	# ENEMY SPAWNING
	# =====================

	enemy_spawn_timer += delta

	if enemy_spawn_timer >= 2:

		spawn_enemy()

		enemy_spawn_timer = 0

	# =====================
	# ORB SPAWNING
	# =====================

	if current_round % 5 == 0:

		if orb_spawned_this_round == false:

			spawn_orb()

			orb_spawned_this_round = true

	# =====================
	# ELEMENT TIMER
	# =====================

	if current_element != "none":

		element_timer -= delta

		if element_timer <= 0:

			current_element = "none"

	# =====================
	# UI
	# =====================

	time_label.text = "Time: " + str(int(survive_time))

	weapon_label.text = "Weapon: " + current_weapon

	element_label.text = "Element: " + current_element

	round_label.text = "Round: " + str(current_round)

	health_label.text = "Health: " + str(health)

	continue_label.text = (
		"Continues: " + str(continues_left)
	)

	save_game()


# =========================
# SHOOTING
# =========================

func shoot():

	# SHOTGUN

	if current_weapon == "shotgun":

		for i in range(5):

			var bullet = bullet_scene.instantiate()

			get_parent().add_child(bullet)

			bullet.global_position = global_position

			var spread = randf_range(-0.2, 0.2)

			var direction = (
				get_global_mouse_position()
				- global_position
			).normalized()

			direction = direction.rotated(spread)

			bullet.direction = direction

			bullet.rotation = direction.angle()

			bullet.element = current_element

			bullet.damage = bullet_damage

	# NORMAL GUNS

	else:

		var bullet = bullet_scene.instantiate()

		get_parent().add_child(bullet)

		bullet.global_position = global_position

		bullet.direction = (
			get_global_mouse_position()
			- global_position
		).normalized()

		bullet.rotation = bullet.direction.angle()

		bullet.element = current_element

		bullet.damage = bullet_damage


# =========================
# WEAPON STATS
# =========================

func update_weapon():

	match current_weapon:

		"glock":

			fire_rate = 0.4

			bullet_damage = 2

		"rifle":

			fire_rate = 0.2

			bullet_damage = 1

		"machine":

			fire_rate = 0.08

			bullet_damage = 1

		"shotgun":

			fire_rate = 0.8

			bullet_damage = 4


# =========================
# ENEMY SPAWNING
# =========================

func spawn_enemy():

	var enemies = [
		fast_enemy_scene,
		tank_enemy_scene,
		fire_enemy_scene,
		water_enemy_scene,
		earth_enemy_scene,
		lightning_enemy_scene,
		wind_enemy_scene
	]

	var enemy = enemies.pick_random().instantiate()

	enemy_spawn.progress_ratio = randf()

	enemy.global_position = (
		enemy_spawn.global_position
	)

	get_parent().add_child(enemy)


# =========================
# ORB SPAWNING
# =========================

func spawn_orb():

	orb_spawn.progress_ratio = randf()

	var orb = orb_scene.instantiate()

	orb.global_position = orb_spawn.global_position

	get_parent().add_child(orb)


# =========================
# ELEMENT
# =========================

func set_element(element):

	current_element = element

	element_timer = element_duration


# =========================
# DAMAGE
# =========================

func take_damage(amount):

	health -= amount

	if health <= 0:

		die()


# =========================
# DEATH
# =========================

func die():

	continues_left -= 1

	if continues_left > 0:

		continue_game()

	else:

		game_over()


# =========================
# CONTINUE
# =========================

func continue_game():

	health = 40

	stamina = 40

	speed -= 10

	fire_rate += 0.05

	global_position = Vector2.ZERO


# =========================
# GAME OVER
# =========================

func game_over():

	DirAccess.remove_absolute(
		"user://save.save"
	)

	get_tree().change_scene_to_file(
		"res://menu.tscn"
	)


# =========================
# SAVE SYSTEM
# =========================

func save_game():

	var save_data = {

		"health": health,

		"round": current_round,

		"continues": continues_left,

		"weapon": current_weapon
	}

	var file = FileAccess.open(
		"user://save.save",
		FileAccess.WRITE
	)

	file.store_var(save_data)


func load_game():

	if FileAccess.file_exists(
		"user://save.save"
	):

		var file = FileAccess.open(
			"user://save.save",
			FileAccess.READ
		)

		var data = file.get_var()

		health = data["health"]

		current_round = data["round"]

		continues_left = data["continues"]

		current_weapon = data["weapon"]
