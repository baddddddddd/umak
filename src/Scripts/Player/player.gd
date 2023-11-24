extends CharacterBody2D

signal bullet_shot(bullet_scene, location)

@onready var stage = $".."
@export var speed=150
@onready var muzzle = $muzzle
@onready var shoot_sound=$shoot_sound
@onready var joystick = preload("res://Scenes/Player/joystick.tscn").instantiate()
@onready var bbm = 0
@onready var double_bullet = false
@onready var ultimate = preload("res://Scenes/Player/ultimate.tscn")
@onready var ult_active = false
@onready var offset = 0

const NUMBER_OF_HP_FRAMES = 6

@onready var start_frame = $"../HealthBar/Fill".frame
@export var max_hp = 100
var hp = max_hp

var invincibility = false
var entered_body = null
@onready var anim = $AnimationPlayer

var shooting = false
var shootingDelay = 0.1
var shootTimer = 0.0
var bullet_scene=preload("res://Scenes/Player/bullet.tscn")
#var bullet_scene=preload("res://Scenes/PowerUps/BBM.tscn")

@onready var artifact_counter_label = $"../ArtifactCounter"


func _ready():
	if OS.get_name() == "Android":
		joystick.position = Vector2(92, 233)
		joystick.scale = Vector2(0.35, 0.35)
		get_tree().current_scene.add_child.call_deferred(joystick)
	
	anim.play("Default")
	Global.player_position = self.global_position
	
	var display_text = str(Global.artifact_collected.size()) + " / 7" 
	#artifact_counter_label.get_node("MarginContainer/VBoxContainer/RichTextLabel").text = "[center]" + display_text + "[/center]"
		
	
	
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed and event.position.x >= (get_viewport_rect().size.x / 2) and not shooting:
			shooting = true
		else:
			shooting = false
	
	elif event is InputEventKey and event.keycode == KEY_SPACE:
		if event.pressed:
			shooting = true
		else:
			shooting = false


func _process(delta):
	shootTimer += delta
	
	if shooting:	
		if shootTimer >= shootingDelay:
			shootTimer = 0
			shoot()
	
	if not invincibility and entered_body != null:
		deplete_hp(30)
	

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	velocity.x *= 0.6


func _physics_process(delta):
	match OS.get_name():
		"Android":
			var direction = joystick.posVector
			if direction and (ult_active == false):
				velocity=direction*speed
			else:
				velocity=Vector2(0,0)
		"Windows":
			get_input()
			
	move_and_slide()
	Global.player_position = self.global_position
	
	
func shoot():
	var bullet_instance = bullet_scene.instantiate()
	var second_bullet_instance = bullet_scene.instantiate()
	if double_bullet:
		bullet_instance.global_position = muzzle.global_position + Vector2(0, 10)
		get_tree().current_scene.add_child(bullet_instance)
		second_bullet_instance.global_position = muzzle.global_position + Vector2(0, -0)
		get_tree().current_scene.add_child(second_bullet_instance)
	else:
		bullet_instance.global_position = muzzle.global_position
		get_tree().current_scene.add_child(bullet_instance)
	#bullet_shot.emit(bullet_scene, muzzle.global_position)
	if bbm > 0:
		bbm -= 1
		if bbm == 0:
			$"../ActivePowerup/Powerup1".visible = false
			bullet_scene=preload("res://Scenes/Player/bullet.tscn")
	
	
func fire_ultimate():
	ult_active = true
	for i in range(20):
		$"..".set_position(Vector2(5, 5))
		await get_tree().create_timer(0.05).timeout
		$"..".set_position(Vector2(-5, 5))
		await get_tree().create_timer(0.05).timeout
		$"..".set_position(Vector2(5, -5))
		await get_tree().create_timer(0.05).timeout
		$"..".set_position(Vector2(-5, -5))
	var ultimate_instance = ultimate.instantiate()
	ultimate_instance.global_position = muzzle.global_position
	get_tree().current_scene.add_child(ultimate_instance)
	await get_tree().create_timer(5.0).timeout
	Global.ultimate_charge = 0
	$"../UltimateButton".visible = false
	ult_active = false
	
func deplete_hp(damage):
	if invincibility:
		return
		
	var bar = max_hp / NUMBER_OF_HP_FRAMES
	var section = hp / bar
	var frame_offset = NUMBER_OF_HP_FRAMES - section
	
	hp -= damage
	
	if hp <= 0:
		set_game_over()
		
	$"../HealthBar/Fill".frame = start_frame + frame_offset 
	
	activate_invincible()
	for i in range(3):
		$"..".set_position(Vector2(2, 2))
		await get_tree().create_timer(0.05).timeout
		$"..".set_position(Vector2(-2, 2))
		await get_tree().create_timer(0.05).timeout
		$"..".set_position(Vector2(2, -2))
		await get_tree().create_timer(0.05).timeout
		$"..".set_position(Vector2(-2, -2))
		
	$AudioStreamPlayer2D2.play()
		
		
func activate_invincible():
	invincibility = true
	anim.play("Invincible")
	
	await get_tree().create_timer(4.2).timeout
	deactivate_invincibility()
	
	
func deactivate_invincibility():
	invincibility = false
	anim.play("Default")
	
		
func set_game_over():
	stage.end_game()


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		entered_body = body
		deplete_hp(30)
	elif body.is_in_group("pickup"):
		Global.artifact_collected.push_back(body)
		var display_text = str(Global.artifact_collected.size()) + " / 7" 
		artifact_counter_label.get_node("MarginContainer/VBoxContainer/RichTextLabel").text = "[center]" + display_text + "[/center]"
		get_tree().current_scene.remove_child(body)
		
		$AudioStreamPlayer2D3.play()
		
	elif body.is_in_group("powerup"):
		if body.is_in_group("powerup1"):
			body.queue_free()
			bullet_scene=preload("res://Scenes/PowerUps/BBM.tscn")
			$"../ActivePowerup/Powerup1".visible = true
			bbm = 3			
		elif body.is_in_group("powerup2"):
			body.queue_free()
			shootingDelay = 0.05
			$"../ActivePowerup/Powerup2".visible = true
			await get_tree().create_timer(5.0).timeout
			$"../ActivePowerup/Powerup2".visible = false
			shootingDelay = 0.1
		elif body.is_in_group("powerup3"): 
			body.queue_free()
			double_bullet = true
			$"../ActivePowerup/Powerup3".visible = true
			await get_tree().create_timer(5.0).timeout
			$"../ActivePowerup/Powerup3".visible = false
			double_bullet = false
		elif body.is_in_group("powerup4"):
			body.queue_free()
			invincibility = true
			$muzzle/Sprite2D.visible = true
			$"../ActivePowerup/Powerup4".visible = true
			await get_tree().create_timer(5.0).timeout
			invincibility = false
			$muzzle/Sprite2D.visible = false
			$"../ActivePowerup/Powerup4".visible = false
			

func _on_area_2d_body_exited(body):
	if entered_body != null:
		if body == entered_body:
			entered_body = null
	
func _on_ultimate_button_pressed():
	fire_ultimate()
	$"../UltimateButton".visible = false
