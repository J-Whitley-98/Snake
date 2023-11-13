extends Control

func _on_classic_snake_pressed():
	get_tree().change_scene_to_file("res://Scenes/GameModes/classic_snake.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
