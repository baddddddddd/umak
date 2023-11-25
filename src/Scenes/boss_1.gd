extends CharacterBody2D

var rng = RandomNumberGenerator.new()

@export var movement_range: Vector2 = Vector2(160, 300)

@export var entrance_speed = 30
@export var max_hp = 5000
var hp = max_hp

@onready var attack_timer = $AttackTimer
@onready var cannon_muzzle = $CannonMuzzle
@onready var laser_muzzle_1 = $LaserMuzzle1
@onready var laser_muzzel_2 = $LaserMuzzle2

@onready var cannon_scene = preload("res://Scripts/Enemy/type_1_bullet.tscn") 
@onready var laser_scene = preload("res://Scripts/Enemy/type_2_bullet.tscn")


func _ready():
	velocity.x = -entrance_speed
	
	await get_tree().create_timer(4.0).timeout
	
	velocity.x = 0
	
	await laser_attack()
	await cannon_attack()
	await move_random()
	
	attack_timer.start()
	$AnimationPlayer.play("moving")

func attack():
	var attacks = [laser_attack, cannon_attack]
	for i in range(2):
		var attack_type = rng.randi_range(0, 1)
		await attacks[attack_type].call()
		
	await move_random()
	await get_tree().create_timer(0.5).timeout
	return await attack()
	
	
func lock_to_player():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SPRING)
	var target_position = Vector2(self.global_position.x, Global.player_position.y)
	var random_duration = rng.randf_range(0.4, 0.7)
	await tween.tween_property(self, "global_position", target_position, random_duration).set_ease(Tween.EASE_OUT).finished
	

func move_random():
	var random_y = rng.randf_range(movement_range.x, movement_range.y)
	
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
	var target_position = Vector2(self.global_position.x, random_y)
	var random_duration = rng.randf_range(0.7, 1.5)
	await tween.tween_property(self, "global_position", target_position, random_duration).set_ease(Tween.EASE_OUT).finished
	
	
func laser_attack():
	await lock_to_player()
	await get_tree().create_timer(0.2).timeout
	
	var laser_bullet = laser_scene.instantiate()
	laser_bullet.global_position = cannon_muzzle.global_position
	laser_bullet.set("speed", 0)
	
	get_tree().current_scene.add_child(laser_bullet)
	
	await get_tree().create_timer(5.0).timeout
	
	
func cannon_fire():
	await lock_to_player()
	await get_tree().create_timer(0.2).timeout
	
	var cannon_bullet = cannon_scene.instantiate()
	cannon_bullet.global_position = cannon_muzzle.global_position
	
	get_tree().current_scene.add_child(cannon_bullet)	
	
	
func cannon_attack():
	for i in range(3):
		await cannon_fire()
		
	await get_tree().create_timer(1.0).timeout	
	
	
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
	queue_free()
	$"..".level_succeed()
	
	
func _physics_process(delta):
	move_and_slide()


func _on_attack_timer_timeout():
	attack()
	
