extends Node2D

var rng = RandomNumberGenerator.new()

var my_random_number = rng.randf_range(-10.0, 10.0)

@export var enemies: Array[PackedScene]

@onready var spawn_area = $SpawnArea/CollisionShape2D
@onready var pause_menu = $PauseMenu
@onready var game_over_screen = $GameOverScreen
var paused = true

@onready var spawn_timer = $EnemySpawnClock
@onready var type_4 = preload("res://Scripts/Enemy/type_4.tscn")

var top_left = Vector2(0, 0)

# Quiz mode
@onready var hud = $Hud


func _ready():
	top_left.x = spawn_area.global_position.x - (spawn_area.shape.size.x * 0.5)
	top_left.y = spawn_area.global_position.y - (spawn_area.shape.size.y * 0.5)
	
	pause_menu.hide()
	game_over_screen.hide()
	
	start_wave()
	
	await get_tree().create_timer(10.0).timeout
	
	var question = "What is my name?"
	var choices = [
		"Vlad",
		"Blado",
		"Lad"
	]
	var answer = "Vladimir"
	
	trigger_qna(question, choices, answer)
	

func _on_enemy_spawn_clock_timeout():
	var number_of_enemies = rng.randi_range(1, 2)
	
	for i in range(number_of_enemies):
		spawn_enemy()
		await get_tree().create_timer(1).timeout


func trigger_qna(question, choices, answer):
	spawn_timer.stop()
	await get_tree().create_timer(3.0).timeout
	
	var correct_answer = rng.randi_range(1, 4)
	
	for i in range(1, 5):
		var y_position = top_left.y + (spawn_area.shape.size.y * (0.20 * i))
		var x_position = top_left.x
		
		var enemy_instance = type_4.instantiate()
		enemy_instance.global_position = Vector2(x_position, y_position)
		
		var banner_text = ""
		
		if i == correct_answer:
			enemy_instance.set("invincible", false)
			banner_text = answer
		else:
			banner_text = choices.pop_front()
			
		get_tree().current_scene.add_child(enemy_instance)
	
	
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


func end_game():
	Engine.time_scale = 0
	game_over_screen.show()
	

func _on_pause_button_pressed():
	pause()
