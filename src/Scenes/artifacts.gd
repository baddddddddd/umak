extends Control

var is_open = false

func _ready():
	close()
	

func close():
	visible = false
	is_open = false

func _on_button_button_down():
	if is_open:
		close()
		Engine.time_scale = 1
	else:
		update_display()
		Engine.time_scale = 0

	
func update_display():
	visible = true
	is_open = true
	for i in range(1, Global.artifact_collected.size() + 1):
		var string_node = "NinePatchRect/ScrollContainer/VBoxContainer/Label" + str(i) + "/artifact_slot/MarginContainer/RichTextLabel"
		var text_label = get_node(string_node)
		text_label.text = Global.artifact_information[i - 1].information
		
		



