extends Node2D

var rng = RandomNumberGenerator.new()

var my_random_number = rng.randf_range(-10.0, 10.0)

@export var enemies: Array[PackedScene]
@export var powerups: Array[PackedScene]

@onready var spawn_area = $SpawnArea/CollisionShape2D
@onready var pause_menu = $PauseMenu
@onready var game_over_screen = $GameOverScreen
var paused = true

@onready var spawn_timer = $EnemySpawnClock
@onready var powerup_timer = $PowerUpSpawnClock
@onready var type_4 = preload("res://Scripts/Enemy/type_4.tscn")
@onready var banner_ui = preload("res://Scenes/banner.tscn")

var top_left = Vector2(0, 0)

# Quiz mode
@onready var hud = $Hud


func _ready():
	top_left.x = spawn_area.global_position.x - (spawn_area.shape.size.x * 0.5)
	top_left.y = spawn_area.global_position.y - (spawn_area.shape.size.y * 0.5)
	
	pause_menu.hide()
	game_over_screen.hide()
	
	start_wave()
	
	await get_tree().create_timer(4.0).timeout
	
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

func _on_power_up_spawn_clock_timeout():
    spawn_powerup()
    await get_tree().create_timer(5).timeout


func show_banner(text):
	hud.get_node("MarginContainer/RichTextLabel").text = text
	
	

func trigger_qna(question, choices, answer):
	spawn_timer.stop()
	await get_tree().create_timer(3.0).timeout
	
	show_banner(question)
	
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
    powerup_timer.start()
    

func spawn_enemy():
    var random_y = rng.randf_range(top_left.y, top_left.y + spawn_area.shape.size.y)
    
    var random_type = rng.randi_range(0, enemies.size() - 1)
    
    var enemy = enemies[random_type].instantiate()
    enemy.global_position = Vector2(top_left.x, random_y)
    
    get_tree().current_scene.add_child(enemy)

func spawn_powerup():
    var random_y = rng.randf_range(top_left.y, top_left.y + spawn_area.shape.size.y)
    
    var random_type = rng.randi_range(0, enemies.size() - 1)
    
    var powerup = powerups[random_type].instantiate()
    powerup.global_position = Vector2(top_left.x, random_y)
    
    get_tree().current_scene.add_child(powerup)
    
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


