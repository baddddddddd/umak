extends Node2D

var rng = RandomNumberGenerator.new()

var my_random_number = rng.randf_range(-10.0, 10.0)

@export var enemies: Array[PackedScene]

@onready var spawn_area = $SpawnArea/CollisionShape2D
@onready var pause_menu = $PauseMenu
@onready var game_over_screen = $GameOverScreen
var paused = true

@onready var spawn_timer = $EnemySpawnClock
@onready var player = $player
@onready var type_4 = preload("res://Scripts/Enemy/type_4.tscn")
@onready var banner_ui = preload("res://Scenes/banner.tscn")

var top_left = Vector2(0, 0)

# Quiz mode
@onready var hud = $Hud


# boss fight
@onready var homing_missile_scene = preload("res://Scenes/homing_missile.tscn")
@onready var boss_scene = preload("res://Scenes/boss_1.tscn")

func _ready():
	top_left.x = spawn_area.global_position.x - (spawn_area.shape.size.x * 0.5)
	top_left.y = spawn_area.global_position.y - (spawn_area.shape.size.y * 0.5)
	
	pause_menu.hide()
	game_over_screen.hide()
	
	#start_wave()
	
	#await get_tree().create_timer(10.0).timeout
	
	var question = "Bibingka came from the word Bebinca which is influenced by ______"
	var choices = [
		"Chinese",
		"Spanish",
		"Russians"
	]
	var answer = "Indians"
	
	#await trigger_qna(question, choices, answer)
	
	#start_wave()
	
	#await get_tree().create_timer(10.0).timeout

	start_bossfight()	
	

func _on_enemy_spawn_clock_timeout():
	var number_of_enemies = rng.randi_range(1, 2)
	
	for i in range(number_of_enemies):
		spawn_enemy()
		await get_tree().create_timer(1).timeout


func show_banner(text):
	hud.get_node("MarginContainer/RichTextLabel").text = text
	
	

func trigger_qna(question, choices, answer):
	spawn_timer.stop()
	await get_tree().create_timer(3.0).timeout
	
	show_banner(question)
	
	await get_tree().create_timer(2.0).timeout
	
	var correct_answer = rng.randi_range(0, 3)
	
	for i in range(4):
		var y_position = top_left.y + (spawn_area.shape.size.y * (0.25 * i)) + 20
		var x_position = top_left.x
		var position = Vector2(x_position, y_position)
		
		if i == correct_answer:
			spawn_type_4(position, answer, false)
		else:
			var banner_text = choices.pop_front()
			spawn_type_4(position, banner_text, true)
			
	await get_tree().create_timer(10.0).timeout
	

func spawn_type_4(position, banner_text, invincible):
	var enemy_instance = type_4.instantiate()
	enemy_instance.global_position = position
	enemy_instance.set("invincible", invincible)
	
	var banner = enemy_instance.get_node("Banner")
	var banner_text_ui = banner.get_node("MarginContainer/RichTextLabel")
	banner_text_ui.text = banner_text
	
	get_tree().current_scene.add_child(enemy_instance)
	banner.show()
	
	
func start_wave():
	spawn_timer.start()
	

func spawn_enemy():
	var random_y = rng.randf_range(top_left.y, top_left.y + spawn_area.shape.size.y)
	
	var random_type = rng.randi_range(0, enemies.size() - 1)
	
	var enemy = enemies[random_type].instantiate()
	enemy.global_position = Vector2(top_left.x, random_y)
	
	get_tree().current_scene.add_child(enemy)


func _on_despawn_body_exited(body):
	if body.get_meta("entity_type") in ["bullet", "enemy"]:
		body.queue_free()
		
func pause():
	if paused:
		pause_menu.show()
		Engine.time_scale = 0
	else:
		pause_menu.hide()
		Engine.time_scale = 1
		
	paused = !paused

func start_bossfight():
	spawn_timer.stop()
	await get_tree().create_timer(5.0).timeout
	
	var boss_body = boss_scene.instantiate()
	boss_body.global_position = spawn_area.global_position
	get_tree().current_scene.add_child(boss_body)
	
	#shoot_missile()
	

func shoot_missile():
	var homing_missile = homing_missile_scene.instantiate()
	homing_missile.set("target_body", player)
	
	homing_missile.global_position = Vector2(150, 150)
	
	get_tree().current_scene.add_child(homing_missile)
	

func end_game():
	Engine.time_scale = 0
	game_over_screen.show()
	

func _on_pause_button_pressed():
	pause()
