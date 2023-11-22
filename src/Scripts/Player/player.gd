extends CharacterBody2D

signal bullet_shot(bullet_scene, location)

@onready var stage = $".."
@onready var joystick = $'../joystick'
@export var speed=150
@onready var muzzle = $muzzle
@onready var shoot_sound=$shoot_sound


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


func _ready():
	anim.play("Default")
	

func _process(delta):
	if Input.is_action_pressed("shoot"):  # Replace "shoot" with your spacebar input action
		shooting = true
	else:
		shooting = false
		shootTimer = 0.0  # Reset the timer when not shooting

	if shooting:
		shootTimer += delta
		if shootTimer > shootingDelay:
			shootTimer = 0.0
			shoot()  # Call your shooting function here
			#shoot_sound.play()
			
	if not invincibility and entered_body != null:
		deplete_hp(30)
		

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	velocity.x *= 0.6


func _physics_process(delta):
	match OS.get_name():
		"Android":
			var direction= joystick.posVector
			if direction:
				velocity=direction*speed
			else:
				velocity=Vector2(0,0)
		"Windows":
			get_input()
			
	move_and_slide()
	
	
func shoot():
	var bullet_instance = bullet_scene.instantiate()
	bullet_instance.global_position = muzzle.global_position
	
	get_tree().current_scene.add_child(bullet_instance)
	#bullet_shot.emit(bullet_scene, muzzle.global_position)
	
	
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


func _on_area_2d_body_exited(body):
	if entered_body != null:
		if body == entered_body:
			entered_body = null
			
