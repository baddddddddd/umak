extends CharacterBody2D

@export var speed = 10
@export var bullet: PackedScene
@export var hp = 100
var rng = RandomNumberGenerator.new()

var my_random_number = rng.randf_range(-10.0, 10.0)


var top_left = Vector2(0, 0)

func _physics_process(delta):
	velocity.x = -speed
	
	move_and_slide()

func _ready():
	_on_timer_timeout()
	
	
func _on_timer_timeout():
	spawn_whirlpool()

func spawn_whirlpool():
	var random_offset = rng.randf_range(40, self.global_position.x)
	var random_x = self.global_position.x - random_offset
	
	var random_y  = rng.randf_range(150, 300)
	var whirlpool = preload("res://Scripts/Enemy/type_3_bullet.tscn").instantiate()
	whirlpool.global_position = Vector2(random_x, random_y)
	
	get_tree().current_scene.add_child(whirlpool)
