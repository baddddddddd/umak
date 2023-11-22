extends RigidBody2D


@export var speed = 50
@export var damage = 50
@onready var player_pos = Global.player_position

func _ready():
	$AnimationPlayer.play("BBM")
	

func _physics_process(delta):
	position = position.move_toward(player_pos, delta * speed)
	if position == player_pos:
		$AnimationPlayer.play("Explosion")
		
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("friendly"):
		body.deplete_hp(damage)
	

