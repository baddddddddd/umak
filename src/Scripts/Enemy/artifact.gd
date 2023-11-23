extends CharacterBody2D

@export var speed = 150

var quiz: Global.QuizInformation

func _ready():
	velocity.x = -speed

func _physics_process(delta):
	move_and_slide()
