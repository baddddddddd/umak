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
	move_and_slide()

func _ready():
	velocity.x = -speed
	hp_fill.hide()
	hp_bar.hide()
	
	await get_tree().create_timer(0.5).timeout
	attack()
	$Timer.start()
	
	await move_random()
	
	
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
	
	
@onready var hp_fill = $HPFill
@onready var hp_bar = $HPBar
func deplete_hp(damage):	
	hp -= damage
	
	hp_fill.size.x = (float(hp) / max_hp) * hp_bar.size.x
	hp_fill.show()
	hp_bar.show()
	
	if hp <= 0:
		destroy()
		
		
func cancel_whirlpool():
	if current_whirlpool != null:
		current_whirlpool.queue_free()
		
	
		
func destroy():
	cancel_whirlpool()
		
	queue_free()
	
func move_random():
	var rng = RandomNumberGenerator.new()
	
	var top_speed = rng.randf_range(-50, 50)
	var duration = rng.randf_range(0.1, 0.7)
	
	var tween = create_tween().set_trans(Tween.TRANS_QUAD)
	await tween.tween_property(self, "velocity", Vector2(velocity.x, top_speed), duration).set_ease(Tween.EASE_IN_OUT).finished
	await get_tree().create_timer(0.5).timeout
	var tween2 = create_tween().set_trans(Tween.TRANS_QUAD)
	await tween2.tween_property(self, "velocity", Vector2(velocity.x, 0), duration).set_ease(Tween.EASE_IN_OUT).finished

	await get_tree().create_timer(3).timeout
	return await move_random()
