extends CharacterBody2D

@export var speed = Constant.PLAYER_SPEED
@export var bullet_scene: PackedScene

# BULLET DAMAGE
var bullet_damage = 1

#animated sprite2d
@onready var animated_sprite = $player/AnimatedSprite2D
#play time tracker
var total_playtime = 0.0
#stamina
@export var stamina_label: Label

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
	print("trying to spawn the boss", current_round)
	var boss
	match current_round:

		5:
			print("Fire boss initiated")
			boss = fire_boss_scene.instantiate()
		10:
			print(" wind boss initiated")
			boss = wind_boss_scene.instantiate()
		15:
			print("water boss initiated")
			boss = water_boss_scene.instantiate()
		20:
			print("ligtning boss initiated")
			boss = lightning_boss_scene.instantiate()
		25:
			print("earth boss initiated")
			boss = earth_boss_scene.instantiate()
	if boss == null:
		
		return

	enemy_spawn.progress_ratio = randf()
	boss.global_position = enemy_spawn.global_position

	get_parent().add_child(boss)

# PLAYER STATS
var health = Constant.STARTING_HEALTH
var stamina: float = Constant.STARTING_STAMINA
var continues_left = Constant.STARTING_CONTINUES
var stamina_drain = Constant.STAMINA_DRAIN
var stamina_recovery = Constant.STAMINA_RECOVERY
var can_shoot = true
var kills = 0
# WEAPON
var current_weapon = Constant.WEAPON_GLOCK
var fire_rate = 0.4
var shoot_timer = 0.0
# ELEMENT
var current_element = Constant.ELEMENT_NONE
var element_timer = 0.0
# ROUND SYSTEM
var enemies_to_kill = Constant.STARTING_ENEMIES
var enemies_killed_this_round = 0
var enemies_spawned_this_round = 0
var current_round = 1
# SPAWN TIMERSm
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
	load_game()
	check_weapon_unlocks()
	update_weapon()
	set_element(current_element)
	current_gun = glock
	
func _physics_process(delta):
	enemy_spawn_timer += delta
	if enemies_spawned_this_round < enemies_to_kill:
		if enemy_spawn_timer >= Constant.ENEMY_SPAWN_DELAY:

			spawn_enemy()

			enemies_spawned_this_round += 1

			enemy_spawn_timer = 0
	
	if current_element != Constant.ELEMENT_NONE:
		element_timer -= delta
		if element_timer <= 0:
			current_element = Constant.ELEMENT_NONE
			animated_sprite.play("Default")
	if current_round % Constant.BOSS_ROUND_INTERVAL ==0:
		if not boss_spawned:
			spawn_boss()
			boss_spawned = true
	if current_round % 5 == 0:

		if orb_spawned_this_round == false:

			spawn_orb()

			orb_spawned_this_round = true
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
#==================
#stamina
#==================
	if direction.length() > Constant.MIN_STAMINA:
		stamina -= stamina_drain * delta
		stamina = max(stamina,Constant.MIN_STAMINA)
		if int(stamina) <=Constant.MIN_STAMINA:
			can_shoot = false
	else:
		stamina += stamina_recovery * delta
		stamina = clamp(stamina, Constant.MIN_STAMINA,Constant.MAX_STAMINA)
		if int(stamina) >= Constant.STARTING_STAMINA:
			can_shoot = true
	if stamina_label:
		stamina_label.text = str(round(stamina))
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
		if can_shoot and shoot_timer <= 0:
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

		Constant.WEAPON_GLOCK:
			glock.visible = true
			fire_rate = Constant.GLOCK_FIRE_RATE
			bullet_damage = Constant.GLOCK_DAMAGE


		Constant.WEAPON_SHOTGUN:
			shotgun.visible = true
			fire_rate = Constant.SHOTGUN_FIRE_RATE
			bullet_damage = Constant.SHOTGUN_DAMAGE


		Constant.WEAPON_MACHINE:
			machinegun.visible = true
			fire_rate = Constant.MACHINE_FIRE_RATE
			bullet_damage = Constant.MACHINE_DAMAGE

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

			bullet.global_position = current_gun.global_position

			var spread = randf_range(-0.2, 0.2)

			var direction = (
				get_global_mouse_position()
				- global_position
			).normalized()

			direction = direction.rotated(spread)

			bullet.direction = direction

			bullet.rotation = direction.angle()

			bullet.element = current_element
			bullet.update_bullet_colour()
			var final_damage = bullet_damage
			match current_element:
				Constant.ELEMENT_FIRE:
					final_damage +=2
				Constant.ELEMENT_WATER:
					final_damage +=3
				Constant.ELEMENT_EARTH:
					final_damage +=4
				Constant.ELEMENT_WIND:
					final_damage +=1
				Constant.ELEMENT_LIGHTNING:
					final_damage +=5
					
			bullet.damage = final_damage

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
		bullet.update_bullet_colour()
		var final_damage = bullet_damage
		match current_element:
			Constant.ELEMENT_FIRE:
				final_damage +=2
			Constant.ELEMENT_WATER:
				final_damage +=3
			Constant.ELEMENT_EARTH:
				final_damage +=4
			Constant.ELEMENT_WIND:
				final_damage +=1
			Constant.ELEMENT_LIGHTNING:
				final_damage +=5
				
		bullet.damage = final_damage


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
		
	if wind_unlocked:
		enemies.append(wind_enemy_scene)
		
	if water_unlocked:
		enemies.append(water_enemy_scene)
		
	if fire_unlocked:
		enemies.append(fire_enemy_scene)
		
	if earth_unlocked:
		enemies.append(earth_enemy_scene)
		
	var enemy = enemies.pick_random().instantiate()

	enemy.health += (current_round - 1) * Constant.ROUND_HEALTH_INCREASE

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
	print(orb_spawn.get_parent())
	get_parent().add_child(orb)

	
# =========================
# ELEMENT
# =========================

func set_element(element):
	current_element = element
	element_timer = Constant.ELEMENT_DURATION
	match element:
		Constant.ELEMENT_NONE:
			$player/AnimatedSprite2D.play("Default")
		Constant.ELEMENT_EARTH:
			$player/AnimatedSprite2D.play("earth")
		Constant.ELEMENT_FIRE:
			$player/AnimatedSprite2D.play("Fire")
		Constant.ELEMENT_WATER:
			$player/AnimatedSprite2D.play("water")
		Constant.ELEMENT_WIND:
			$player/AnimatedSprite2D.play("wind")
		Constant.ELEMENT_LIGHTNING:
			$player/AnimatedSprite2D.play("lightning")
	


# =========================
# DAMAGE
# =========================

func take_damage(amount):

	health -= amount

	if health <= 0:
		health = 0
		die()


# =========================
# DEATH
# =========================

func die():

	if continues_left > 0:
		continues_left-=1
		continue_game()
	else:
		game_over()

# =========================
# CONTINUE
# =========================

func continue_game():
	health=Constant.STARTING_HEALTH
	stamina = Constant.STARTING_STAMINA
	speed -= Constant.CONTINUE_SPEED_LOSS
	fire_rate += 0.05
	global_position = Vector2.ZERO


# =========================
# GAME OVER
# =========================

func game_over():

	DirAccess.remove_absolute("user://save.save")
	call_deferred("_go_to_end_game")
func _go_to_end_game():
	get_tree().change_scene_to_file(
		"res://scenes/end_game.tscn"
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

	if FileAccess.file_exists("user://save.save"):
		var file = FileAccess.open("user://save.save",FileAccess.READ)

		var data = file.get_var()

		health = data["health"]

		current_round = data["round"]

		continues_left = data["continues"]

		current_weapon = data["weapon"]
		kills = data["kills"]
		enemies_to_kill = current_round * Constant.ENEMY_PER_ROUND
		enemies_killed_this_round = 0
		enemies_spawned_this_round = 0
		boss_spawned = false
		orb_spawned_this_round = false
		check_weapon_unlocks()
		update_weapon()
		
func recoil():
	
	var tween = get_tree().create_tween()

	if current_weapon == Constant.WEAPON_GLOCK:

		tween.tween_property(glock, "position", Vector2(-10, 0), 0.05)
		tween.tween_property(glock, "position", Vector2(0, 0), 0.08)

	if current_weapon == Constant.WEAPON_SHOTGUN:

		tween.tween_property(shotgun, "position", Vector2(-15, 0), 0.05)
		tween.tween_property(shotgun, "position", Vector2(0, 0), 0.08)

	if current_weapon == Constant.WEAPON_MACHINE:

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
func enemy_killed():
	enemies_killed_this_round += 1
	if enemies_killed_this_round>=enemies_to_kill:
		start_new_round()
		
func start_new_round():
	current_round +=1
	enemies_to_kill += Constant.ENEMY_PER_ROUND
	enemies_killed_this_round =0
	enemies_spawned_this_round= 0
	boss_spawned = false
	orb_spawned_this_round = false
	check_weapon_unlocks()
	if current_round == Constant.FIRE_ENEMY_UNLOCK_ROUND:
		fire_unlocked = true
	if current_round == Constant.WIND_ENEMY_UNLOCK_ROUND:
		wind_unlocked = true
	if current_round == Constant.EARTH_ENEMY_UNLOCK_ROUND:
		earth_unlocked = true
	if current_round == Constant.WATER_ENEMY_UNLOCK_ROUND:
		water_unlocked = true
	if current_round == Constant.LIGHTNING_ENEMY_UNLOCK_ROUND:
		lightning_unlocked = true
func check_weapon_unlocks():
	var target_weapon = Constant.WEAPON_GLOCK
	if current_round >= Constant.ROUND_UNLOCK_MACHINE:
		target_weapon = Constant.WEAPON_MACHINE
	elif  current_round>= Constant.ROUND_UNLOCK_SHOTGUN:
		target_weapon = Constant.WEAPON_SHOTGUN
	if current_weapon != target_weapon:
		current_weapon = target_weapon
		update_weapon()
		
#================
#TIMER
#================
