extends CharacterBody2D

signal bullet_shot(bullet_scene, location)

@onready var joystick = $'../joystick'
@export var speed=500
@onready var muzzle = $muzzle
@onready var shoot_sound=$shoot_sound

var shooting = false
var shootingDelay = 0.1
var shootTimer = 0.0
var bullet_scene=preload("res://Scenes/bullet.tscn")


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
			shoot_sound.play()

func _physics_process(delta):
	var direction= joystick.posVector
	if direction:
		velocity=direction*speed
	else:
		velocity=Vector2(0,0)
	move_and_slide()
	
	
func shoot():
	bullet_shot.emit(bullet_scene, muzzle.global_position)

