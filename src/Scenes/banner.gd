extends Control

@export var follow: Node2D = null


func _process(delta):
	if follow != null:
		print(follow)
		self.global_position = Vector2(follow.global_position.x + 40, follow.global_position.y)
