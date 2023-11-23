extends RigidBody2D


@export var speed = 50
@export var damage = 50
@onready var player_pos = Global.player_position
@onready var max_height = false
@onready var to_drop = true

func _ready():
	$AnimationPlayer.play("BBM")
	
	

func _physics_process(delta):
	if max_height == false:
		position = position.move_toward(Vector2(position.x, -100), delta * (speed*7))
		await get_tree().create_timer(1.0).timeout
		max_height = true
	elif to_drop == true:
		position = Vector2(player_pos.x, -100)
		to_drop = false
	else:
		position = position.move_toward(player_pos, delta * (speed*7))
		
		if position == player_pos:
			$AnimationPlayer.play("Explosion")
			await get_tree().create_timer(0.25).timeout
			queue_free()
		

func _on_area_2d_body_entered(body):
	if body.is_in_group("friendly"):
		body.deplete_hp(damage)
	

