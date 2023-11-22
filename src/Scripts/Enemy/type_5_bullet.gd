extends RigidBody2D

@export var speed = 50
@export var damage = 100
@onready var state = 0

func _physics_process(delta):
	
	if state == 0:
		print("up")
		linear_velocity = Vector2(speed, -100)
		state = 1
	elif state == 1:
		print("down")
		linear_velocity = Vector2(speed, 100)
		state = 0

func _on_body_entered(body):
	if body.is_in_group("friendly"):
		if body.has_method("deplete_hp"):
			body.deplete_hp(damage)
			
	queue_free()
