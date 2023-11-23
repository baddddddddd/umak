extends CharacterBody2D

@export var speed: int
@export var bullet: PackedScene
@export var max_hp: int
@onready var hp = max_hp
var current_laser = null

func _ready():
	velocity.x = -speed
	hp_fill.hide()
	hp_bar.hide()
	
	await get_tree().create_timer(0.5).timeout
	attack()
	$Timer.start()
	

func _physics_process(delta):
	move_and_slide()
	
	
func attack():
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_position = $BulletSpawn.global_position
	get_tree().current_scene.add_child(bullet_instance)

	current_laser = bullet_instance


func _on_timer_timeout():
	attack()
	
@onready var hp_fill = $HPFill
@onready var hp_bar = $HPBar
func deplete_hp(damage):	
	hp -= damage
	
	hp_fill.size.x = (float(hp) / max_hp) * hp_bar.size.x
	hp_fill.show()
	hp_bar.show()
	
	if hp <= 0:
		destroy()
		
func destroy():
	if current_laser != null:
		current_laser.queue_free()
	queue_free()
