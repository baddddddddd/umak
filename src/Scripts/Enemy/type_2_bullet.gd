extends CharacterBody2D

@export var speed = 10

@onready var anim = $AnimationPlayer

func _ready():
	start_attack()

func _physics_process(delta):
	velocity.x = -speed
	move_and_slide()


func start_attack():
	charge()
	await get_tree().create_timer(3.0).timeout
	fire()
	await get_tree().create_timer(1.0).timeout
	queue_free()
		
func charge():
	print("Chareg")
	anim.play("Charging")
	
	
func fire():
	print("FIre")
	anim.play("Fire")
	

