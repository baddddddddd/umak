extends Node2D

var rng = RandomNumberGenerator.new()

var my_random_number = rng.randf_range(-10.0, 10.0)

@export var enemies: Array[PackedScene]

@onready var spawn_area = $SpawnArea/CollisionShape2D

var top_left = Vector2(0, 0)

func _ready():
	top_left.x = spawn_area.global_position.x - (spawn_area.shape.size.x * 0.5)
	top_left.y = spawn_area.global_position.y - (spawn_area.shape.size.y * 0.5)
	

func _on_enemy_spawn_clock_timeout():
	var number_of_enemies = rng.randi_range(1, 2)
	
	for i in range(number_of_enemies):
		spawn_enemy()
		await get_tree().create_timer(1).timeout


func spawn_enemy():
	var random_y = rng.randf_range(top_left.y, top_left.y + spawn_area.shape.size.y)
	
	var random_type = rng.randi_range(0, enemies.size() - 1)
	
	var enemy = enemies[random_type].instantiate()
	enemy.global_position = Vector2(top_left.x, random_y)
	
	get_tree().get_root().add_child(enemy)


func _on_despawn_body_exited(body):
	if body.get_meta("entity_type") in ["bullet", "enemy"]:
		get_tree().get_root().remove_child(body)
