extends CharacterBody2D

@export var speed: int
@export var bullet: PackedScene
@export var max_hp: int
@onready var hp = max_hp
var rng = RandomNumberGenerator.new()

var current_whirlpool = null
var my_random_number = rng.randf_range(-10.0, 10.0)


var top_left = Vector2(0, 0)

func _physics_process(delta):
	velocity.x = -speed
	
	move_and_slide()

func _ready():
	await get_tree().create_timer(0.5).timeout
	attack()
	$Timer.start()
	
	
func attack():
	spawn_whirlpool()
	
	
func _on_timer_timeout():
	attack()

func spawn_whirlpool():
	if current_whirlpool != null:
		cancel_whirlpool()
		
	var random_offset = rng.randf_range(40, self.global_position.x)
	var random_x = self.global_position.x - random_offset
	
	var random_y  = rng.randf_range(150, 300)
	var whirlpool = bullet.instantiate()
	whirlpool.global_position = Vector2(random_x, random_y)
	
	current_whirlpool = whirlpool
	
	get_tree().current_scene.add_child(whirlpool)
	
	
func deplete_hp(damage):
	hp -= damage
	
	if hp <= 0:
		destroy()
		
		
func cancel_whirlpool():
	if current_whirlpool != null:
		current_whirlpool.queue_free()
		
	
		
func destroy():
	cancel_whirlpool()
		
	queue_free()
