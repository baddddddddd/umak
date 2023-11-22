extends CharacterBody2D

@export var speed = 40

func _ready():
	$AnimationPlayer.play("Powerup3")
	
func _physics_process(delta):
	velocity.x = -speed
	
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group("friendly"):
		queue_free()
		
