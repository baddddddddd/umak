extends RigidBody2D


@export var target_body: Node2D = null

func _physics_process(delta):
	if target_body != null:
		look_at(target_body.global_position)
