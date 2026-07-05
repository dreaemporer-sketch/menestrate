extends CharacterBody2D

@export var speed = 250
@export var bullet_scene: PackedScene

# BULLET DAMAGE
var bullet_damage = 1

# ENEMIES
@export var normal_enemy_scene: PackedScene
@export var fast_enemy_scene: PackedScene
@export var tank_enemy_scene: PackedScene
@export var fire_enemy_scene: PackedScene
@export var water_enemy_scene: PackedScene
@export var earth_enemy_scene: PackedScene
@export var lightning_enemy_scene: PackedScene
@export var wind_enemy_scene: PackedScene
#shift lock
var shift_locked = false

# ORB
@export var orb_scene: PackedScene

# SPAWN PATHS
@export var enemy_spawn: PathFollow2D
@export var orb_spawn: PathFollow2D

# Enemy Boss
var boss_spawned = false

var fire_unlocked = false
var wind_unlocked = false
var water_unlocked = false
var lightning_unlocked = false
var earth_unlocked = false

@export var fire_boss_scene: PackedScene
@export var wind_boss_scene: PackedScene
@export var water_boss_scene: PackedScene
@export var lightning_boss_scene: PackedScene
@export var earth_boss_scene: PackedScene
func spawn_boss():

	var boss

	match current_round:

		5:
			boss = fire_boss_scene.instantiate()

		10:
			boss = wind_boss_scene.instantiate()

		15:
			boss = water_boss_scene.instantiate()

		20:
			boss = lightning_boss_scene.instantiate()

		25:
			boss = earth_boss_scene.instantiate()

	if boss == null:
		return

	enemy_spawn.progress_ratio = randf()

	boss.global_position = enemy_spawn.global_position

	get_parent().add_child(boss)

# PLAYER STATS
var health = 100
var stamina = 100

var continues_left = 10
var kills = 0
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
var play_game =false
#guns
@export var glock:Sprite2D
@export var shotgun:Sprite2D
@export var machinegun:Sprite2D
var current_gun

func _ready():

	randomize()

	add_to_group("player")
	
	update_weapon()
	
	load_game()

	current_gun = glock
	
func _physics_process(delta):
	enemy_spawn_timer += delta
	survive_time += delta
	print(survive_time)
	if survive_time >= 60:
		current_round += 1
		survive_time = 0
		orb_spawned_this_round=false
		boss_spawned = false
	var spawn_delay = max(0.3, 2.0 - current_round * 0.15)
	if enemy_spawn_timer >= spawn_delay:
		spawn_enemy()

		enemy_spawn_timer = 0
	
	if current_element != "none":

		element_timer -= delta

		if element_timer <= 0:

			current_element = "none"
	if current_round in [5, 10, 15, 20, 25]:
		if boss_spawned == false:
			spawn_boss()
			boss_spawned = true
	# ====================
	# Elemental timer
	# =====================
	# PAUSE
	# =====================

	# =====================
	# MOVEMENT
	# =====================

	var direction = Input.get_vector(
		"move_left",
		"move_right", 
		"move_up",
		"move_down"
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
func update_weapon():

	glock.visible = false
	shotgun.visible = false
	machinegun.visible = false


	match current_weapon:

		"glock":
			glock.visible = true
			fire_rate = 0.6
			bullet_damage = 4


		"shotgun":
			shotgun.visible = true
			fire_rate = 0.9
			bullet_damage = 5


		"machine":
			machinegun.visible = true
			fire_rate = 0.1
			bullet_damage = 3

	# =====================
	# ROUND TIMER
	# =====================

	# =====================
	# ENEMY SPAWNING
	# =====================


	# =====================
	# ORB SPAWNING
	# =====================

	if current_round % 5 == 0:

		if orb_spawned_this_round == false:

			spawn_orb()

			orb_spawned_this_round = true

	# =====================
	# UI
	# =====================

	save_game()


# =========================
# SHOOTING
# =========================

func shoot():
	recoil()
	# SHOTGUN

	if current_weapon == "shotgun":

		for i in range(5):

			var bullet = bullet_scene.instantiate()

			get_parent().add_child(bullet)

			bullet.global_position = glock.global_position

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

		bullet.global_position = current_gun.global_position
	

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

# =========================
# ENEMY SPAWNING
# =========================

func spawn_enemy():

	var enemies = [
		normal_enemy_scene
	]

	if current_round >= 2:
		enemies.append(fast_enemy_scene)

	if current_round >= 3:
		enemies.append(tank_enemy_scene)

	if lightning_unlocked:
		enemies.append(lightning_enemy_scene)
	if water_unlocked:
		enemies.append(wind_enemy_scene)
	if water_unlocked:
		enemies.append(water_enemy_scene)
	if fire_unlocked:
		enemies.append(fire_enemy_scene)
	if earth_unlocked:
		enemies.append(earth_enemy_scene)
	var enemy = enemies.pick_random().instantiate()

	enemy.health += current_round - 1

	enemy_spawn.progress_ratio = randf()

	enemy.global_position = enemy_spawn.global_position

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

		"weapon": current_weapon,
		"kills" : kills
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
		kills = data["kills"]
		update_weapon()
func recoil():
	
	var tween = get_tree().create_tween()

	if current_weapon == "glock":

		tween.tween_property(glock, "position", Vector2(-10, 0), 0.05)
		tween.tween_property(glock, "position", Vector2(0, 0), 0.08)

	if current_weapon == "shotgun":

		tween.tween_property(shotgun, "position", Vector2(-15, 0), 0.05)
		tween.tween_property(shotgun, "position", Vector2(0, 0), 0.08)

	if current_weapon == "machine":

		tween.tween_property(machinegun, "position", Vector2(-8, 0), 0.05)
		tween.tween_property(machinegun, "position", Vector2(0, 0), 0.08)

	# =====================
	# SHIFT LOCK TOGGLE
	# =====================
	if Input.is_action_just_pressed("shift lock"):
		if shift_locked == false:
			shift_locked = true
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
		else:
			shift_locked = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
