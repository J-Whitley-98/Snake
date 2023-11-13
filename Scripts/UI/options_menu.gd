class_name options_menu extends Control

#Back button
func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
