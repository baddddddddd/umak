extends RigidBody2D

@export var speed = 200
@export var damage = 10

func _physics_process(delta):
	linear_velocity = Vector2(-speed, 0)
	


func _on_body_entered(body):
	if body.is_in_group("friendly"):
		if body.has_method("deplete_hp"):
			body.deplete_hp(damage)
			
	queue_free()
