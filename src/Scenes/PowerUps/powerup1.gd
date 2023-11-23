extends CharacterBody2D

@export var speed = 150

func _ready():
	$AnimationPlayer.play("Bob")
	velocity.x = -speed

func _physics_process(delta):
	move_and_slide()
