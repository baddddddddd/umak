extends Control

@export var next_stage: PackedScene

func _on_next_pressed():
	get_tree().change_scene_to_packed(next_stage)


func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Scenes/StageOne.tscn")


func _on_quit_pressed():
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
