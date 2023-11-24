extends CharacterBody2D

@export var speed = 150
@export var suction_speed = 300
var entered = false
var target_body
var shake_threshold = 10.0
var shake_time_threshold = 0.5
var elapsed_time_since_shake = 0.0
@onready var warning = preload("res://Scenes/Warning.tscn").instantiate()
@onready var full = false
@onready var a = 0

func _ready():
	$AnimationPlayer.play("Whirlpool")
	get_tree().current_scene.add_child(warning)
	warning.visible = false
	

func blink():
	for i in range(3):
		$"..".set_position(Vector2(2, 2))
		await get_tree().create_timer(0.05).timeout
		$"..".set_position(Vector2(-2, 2))
		await get_tree().create_timer(0.05).timeout
		$"..".set_position(Vector2(2, -2))
		await get_tree().create_timer(0.05).timeout
		$"..".set_position(Vector2(-2, -2))
	var tween = create_tween().set_trans(Tween.TRANS_QUAD)
	await tween.tween_property(warning, "modulate", Color(1, 1, 1, 0), 0.5).set_ease(Tween.EASE_IN_OUT).finished
	
	var tween2 = create_tween().set_trans(Tween.TRANS_QUAD)	
	await tween2.tween_property(warning, "modulate", Color(1, 1, 1, 0.5), 0.5).set_ease(Tween.EASE_IN_OUT).finished
	return await blink()

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
					warning.visible = false
	
func _physics_process(delta):
	velocity.x = -speed
	
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("friendly"):
		target_body = body
		entered = true
		warning.visible = true
		await blink()

func _on_area_2d_body_exited(body):
	if entered:
		entered = not entered
		warning.visible = false


