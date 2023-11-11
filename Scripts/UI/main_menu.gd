extends Control

#func _ready():
#	ClassicSnake.connect("main_menu_pressed", _called_by_pause, 0)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/GameModes/classic_snake.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/options_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()

#func _called_by_pause():
#	get_tree().reload_current_scene()
#	print_debug("reload?")
