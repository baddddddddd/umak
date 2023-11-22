extends CharacterBody2D

@export var speed = 40
@export var suction_speed = 300
var entered = false
var target_body
var shake_threshold = 10.0
var shake_time_threshold = 0.5
var elapsed_time_since_shake = 0.0

func _ready():
	$AnimationPlayer.play("Whirlpool")
	

func _process(delta):
	if entered:
		var direction = (self.global_position - target_body.global_position).normalized()
		target_body.global_position += direction * suction_speed * delta
		var acceleration = Input.get_accelerometer()
		var acceleration_length = acceleration.length()

		if acceleration_length > shake_threshold:
			if acceleration_length > shake_threshold:
				elapsed_time_since_shake += delta
				if elapsed_time_since_shake > shake_time_threshold:
					suction_speed = 0
					elapsed_time_since_shake = 0.0
	
func _physics_process(delta):
	velocity.x = -speed
	
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("friendly"):
		target_body = body
		entered = true

func _on_area_2d_body_exited(body):
	if entered:
		entered = not entered


