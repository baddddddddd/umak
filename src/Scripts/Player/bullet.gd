extends RigidBody2D

@export var speed = 500
@export var damage = 20


func _physics_process(delta):
	linear_velocity = Vector2(speed, 0)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		if body.has_method("deplete_hp"):
			body.deplete_hp(damage)
			
		queue_free()

