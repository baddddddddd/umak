extends CharacterBody2D

@export var speed = 10
@export var bullet: PackedScene
@export var hp = 100


func _physics_process(delta):
	velocity.x = -speed
	
	move_and_slide()
	
	
func attack():
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_position = $BulletSpawn.global_position
	get_tree().get_root().add_child(bullet_instance)


func _on_timer_timeout():
	attack()
