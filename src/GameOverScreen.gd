extends Control


func _on_retry_pressed():
	Engine.time_scale = 1
	get_tree().reload_current_scene()


func _on_quit_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
