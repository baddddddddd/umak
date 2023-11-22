extends CharacterBody2D

@export var speed = 20
@export var bullet: PackedScene
@export var hp = 150


func _ready():
	await get_tree().create_timer(1.0).timeout
	attack()
	$Timer.start()

func _physics_process(delta):
	velocity.x = -speed
	
	move_and_slide()
	
	
func attack():
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_position = $BulletSpawn.global_position
	
	get_tree().current_scene.add_child(bullet_instance)


func _on_timer_timeout():
	attack()

		
func deplete_hp(damage):
	hp -= damage
	
	if hp <= 0:
		destroy()
		
func destroy():
	queue_free()
