extends CharacterBody2D

@export var speed = 40
@export var firing = false
@onready var anim = $AnimationPlayer

func _ready():
	start_attack()

func _physics_process(delta):
	velocity.x = -speed
	move_and_slide()


func start_attack():
	firing = false
	charge()
	await get_tree().create_timer(3.0).timeout
	fire()
	await get_tree().create_timer(1.0).timeout
	
	queue_free()
		
func charge():
	anim.play("Charging")
	
	
func fire():
	firing = true
	anim.play("Fire")
	

