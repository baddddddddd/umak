extends CharacterBody2D

var rng = RandomNumberGenerator.new()

@export var movement_range: Vector2 = Vector2(160, 300)

@export var entrance_speed = 30
@export var max_hp = 6000
var hp = max_hp

@onready var attack_timer = $AttackTimer
@onready var cannon_muzzle = $CannonMuzzle
@onready var laser_muzzle_1 = $LaserMuzzle1
@onready var laser_muzzel_2 = $LaserMuzzle2

@onready var cannon_scene = preload("res://Scripts/Enemy/type_1_bullet.tscn") 
@onready var laser_scene = preload("res://Scripts/Enemy/type_2_bullet.tscn")
@onready var whirlpool_scene = preload("res://Scripts/Enemy/type_3_bullet.tscn")
@onready var curve_scene = preload("res://Scripts/Enemy/type_5_bullet.tscn")
@onready var missile_scence = preload("res://Scripts/Enemy/type_6_bullet.tscn")
@onready var homing_scene = preload("res://Scripts/Enemy/type_6_bullet.tscn")


func _ready():
	velocity.x = -entrance_speed
	
	await get_tree().create_timer(4.0).timeout
	
	velocity.x = 0
	
	await homing_missile_attack()
	await missile_attack()
	await curve_attack()
	await whirlpool_attack()
	await laser_attack()
	await cannon_attack()
	await move_random()
	
	attack_timer.start()
	$AnimationPlayer.play("moving")

func attack():
	var attacks = [laser_attack, cannon_attack, whirlpool_attack, curve_attack, missile_attack, homing_missile_attack]
	for i in range(4):
		var attack_type = rng.randi_range(0, 1)
		await attacks[attack_type].call()
		
	await move_random()
	await get_tree().create_timer(0.5).timeout
	return await attack()
	
	
func lock_to_player():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SPRING)
	var target_position = Vector2(self.global_position.x, Global.player_position.y)
	var random_duration = rng.randf_range(0.3, 0.5)
	await tween.tween_property(self, "global_position", target_position, random_duration).set_ease(Tween.EASE_OUT).finished
	

func move_random():
	var random_y = rng.randf_range(movement_range.x, movement_range.y)
	
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
	var target_position = Vector2(self.global_position.x, random_y)
	var random_duration = rng.randf_range(0.5, 1.2)
	await tween.tween_property(self, "global_position", target_position, random_duration).set_ease(Tween.EASE_OUT).finished
	
	
	
func laser_attack():
	await lock_to_player()
	await get_tree().create_timer(0.2).timeout
	
	var laser_bullet = laser_scene.instantiate()
	laser_bullet.global_position = cannon_muzzle.global_position
	laser_bullet.set("speed", 0)
	
	get_tree().current_scene.add_child(laser_bullet)
	
	await get_tree().create_timer(4.5).timeout
	
	
func cannon_fire():
	await lock_to_player()
	await get_tree().create_timer(0.2).timeout
	
	var cannon_bullet = cannon_scene.instantiate()
	cannon_bullet.global_position = cannon_muzzle.global_position
	
	get_tree().current_scene.add_child(cannon_bullet)	
	
	
func cannon_attack():
	for i in range(5):
		await cannon_fire()
		
	await get_tree().create_timer(0.3).timeout	
		
	
func whirlpool_attack():
	for i in range(3):
		await summon_whirlpool()
		
	await get_tree().create_timer(0.3).timeout
	
func summon_whirlpool():
	var random_offset = rng.randf_range(40, self.global_position.x)
	var random_x = self.global_position.x - random_offset
	
	var random_y  = rng.randf_range(150, 300)
	var whirlpool = whirlpool_scene.instantiate()
	whirlpool.global_position = Vector2(random_x, random_y)
	
	get_tree().current_scene.add_child(whirlpool)
	
	await get_tree().create_timer(0.5).timeout
	
	
func curve_attack():
	await lock_to_player()
	await get_tree().create_timer(0.2).timeout
	
	var curve_bullet = curve_scene.instantiate()
	curve_bullet.global_position = cannon_muzzle.global_position
	
	get_tree().current_scene.add_child(curve_bullet)
	
	
func missile_attack():
	move_random()
	
	await get_tree().create_timer(0.2).timeout
	
	var missile_bullet = missile_scence.instantiate()
	missile_bullet.global_position = cannon_muzzle.global_position
	
	get_tree().current_scene.add_child(missile_bullet)
	
	
func homing_missile_attack():
	await get_tree().create_timer(0.2).timeout
	
	var homing_missile = homing_scene.instantiate()
	homing_missile.global_position = cannon_muzzle.global_position
	
	get_tree().current_scene.add_child(homing_missile)	
	
	
func deplete_hp(damage):
	hp -= damage
	print(hp)
	if hp <= 0:
		destroy()
		
		
func destroy():
	queue_free()
	proceed_to_next_stage()
	
func proceed_to_next_stage():
	get_tree().change_scene_to_file("res://Scenes/StageThree.tscn")
	
	
func _physics_process(delta):
	move_and_slide()


func _on_attack_timer_timeout():
	attack()
	
