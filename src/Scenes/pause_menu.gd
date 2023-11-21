extends Control

@onready var stage = $".."

func _on_resume_pressed():
	stage.pause()


func _on_quit_pressed():
	stage.pause()
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")


func _on_restart_pressed():
	stage.pause()
	get_tree().reload_current_scene()
