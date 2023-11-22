extends RigidBody2D


@export var speed = 100
@export var damage = 100

var in_radius = []

func _ready():
	$AnimationPlayer.play("BBM")
	linear_velocity = Vector2(speed, 0)
	

func _physics_process(delta):
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		$AnimationPlayer.play("Explosion")
		for enemy in in_radius:
			enemy.deplete_hp(damage)
		
		linear_velocity = Vector2(-40, 0)
		
		await get_tree().create_timer(1.0).timeout
		queue_free()
		

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		in_radius.push_back(body)

func _on_area_2d_body_exited(body):
	if body.is_in_group("enemy"):
		if body in in_radius:
			in_radius.erase(body)
