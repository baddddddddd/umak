extends CharacterBody2D

@export var speed = 40
@export var suction_speed = 100
var entered = false
var target_body

func _ready():
	$AnimationPlayer.play("Whirlpool")
	

func _process(delta):
	if entered:
		var direction = (self.global_position - target_body.global_position).normalized()
		
		target_body.global_position += direction * suction_speed * delta
	
	
func _physics_process(delta):
	velocity.x = -speed
	
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.has_method("shoot"):
		target_body = body
		entered = true
		


func _on_area_2d_body_exited(body):
	if entered:
		entered = not entered


