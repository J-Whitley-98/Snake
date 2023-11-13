class_name main_menu extends Control

#--------------------Menu Logic--------------------
func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/game_mode_menu.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/options_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
