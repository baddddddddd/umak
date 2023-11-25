extends CharacterBody2D

@export var speed = 50
@export var hp = 500
@export var invincible: bool = true

func _ready():
	$Banner.hide()
	$AnimationPlayer.play("moving")


func _physics_process(delta):
	velocity.x = -speed
	
	move_and_slide()
	
		
func deplete_hp(damage):
	if invincible:
		return
		
		
	hp -= damage
	
	if hp <= 0:
		destroy_wave()
		
		
func destroy_wave():
	$"..".destroy_qna()	
		
		
func destroy():
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	queue_free()
