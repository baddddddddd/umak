extends CharacterBody2D

@export var speed = 60

var quiz: Global.QuizInformation

func _ready():
	velocity.x = -speed

func _physics_process(delta):
	move_and_slide()
