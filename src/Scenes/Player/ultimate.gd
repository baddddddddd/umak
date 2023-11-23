extends CharacterBody2D

@export var speed = 0
@export var firing = false
@onready var anim = $AnimationPlayer
@onready var ultieffect = preload("res://Scenes/UltiEffect.tscn").instantiate()

func _ready():
	start_attack()
	get_tree().current_scene.add_child(ultieffect)

func _physics_process(delta):
	velocity.x = speed
	move_and_slide()

func blink():
	var tween = create_tween().set_trans(Tween.TRANS_QUAD)
	await tween.tween_property(ultieffect, "modulate", Color(0, 0, 0, 0), 3.0).set_ease(Tween.EASE_IN_OUT).finished
	
func start_attack():
	blink()
	print("blinked")
	await get_tree().create_timer(10.0).timeout
	print("timeoutfinish")
	fire()
	await get_tree().create_timer(3.0).timeout
	
	queue_free()
	ultieffect.queue_free()
		
func charge():
	print("charge")
	anim.play("Charging")
	
	
func fire():
	print("firing")
	firing = true
	

