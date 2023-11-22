extends CharacterBody2D

@export var speed: int
@export var bullet: PackedScene
@export var max_hp: int
@onready var hp = max_hp
var current_laser = null

func _ready():
	await get_tree().create_timer(0.5).timeout
	attack()
	$Timer.start()
	

func _physics_process(delta):
	velocity.x = -speed
	
	move_and_slide()
	
	
func attack():
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_position = $BulletSpawn.global_position
	get_tree().current_scene.add_child(bullet_instance)

	current_laser = bullet_instance


func _on_timer_timeout():
	attack()
	
func deplete_hp(damage):
	hp -= damage
	
	if hp <= 0:
		destroy()
		
func destroy():
	if current_laser != null:
		current_laser.queue_free()
	queue_free()
