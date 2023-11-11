extends Node3D

#<emitting_node>.connect("signal_name", <target_node>, "target_method_name")

#--------------------------VARIABLES--------------------------------------------
@onready var ground = $GridGenerator
@onready var food_spawner = $FoodSpawner
@onready var snake_head = preload("res://Scenes/Snake/head.tscn")

var snake_speed = 0.5
var grid_size

signal main_menu_pressed

#-------------------------------------------------------------------------------

#--------------------------GAME-------------------------------------------------
func _ready():
	#temporary line before menu sets defaults and what not
	grid_size = ground.grid_size
	$World/CanvasLayer/PauseMenu.visible = false
	$World/CanvasLayer/DeathMenu.visible = false
	
func _on_begin_pressed():
	_begin()
	
func _begin():
	ground._instantiate_ground()
	
	food_spawner.spawn_points = ground.spawn_points
	food_spawner.food_spawn_timer.start()
	
	$World/CanvasLayer/PreGameMenu.visible = false
	
	instantiate_head()

func restart():
	$World/CanvasLayer/DeathMenu.visible = false
	instantiate_head()

func _input(event):
	if(event.is_action_released("Escape") and snake_head):
		get_tree().paused = true
		$World/CanvasLayer/PauseMenu.visible = true

func instantiate_head():
	snake_head = snake_head.instantiate()
	snake_head.position = Vector3(0,1,0)
	snake_head.forward = "up"
	$Snake.add_child(snake_head)
	snake_head.connect("snake_death", _on_snake_death, 0)
	snake_head._set_bounds(ground.grid_size)
	snake_head.move_timer.set_wait_time(snake_speed)

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
#-------------------------------------------------------------------------------

func _on_continue_pressed():
	get_tree().paused = false
	$World/CanvasLayer/PauseMenu.visible = false

func _on_quit_game_pressed():
	get_tree().quit()
	
func _on_snake_death(length):
	$World/CanvasLayer/DeathMenu/VBoxContainer/FinalSnakeLength.text = ("Final Snake Length: " + str(length))
	$World/CanvasLayer/DeathMenu.visible = true
	
func _on_restart_pressed():
	snake_head = load("res://Scenes/Snake/head.tscn")
	restart()

func _on_map_size_item_selected(index):
	if index == 0:
		ground.grid_size = 5 
	elif index == 1:
		ground.grid_size = 7
	else:
		ground.grid_size = 9
	
func _on_snake_speed_item_selected(index):
	if index == 0:
		snake_speed = 1
	elif index == 1:
		snake_speed = .75
	elif index == 2:
		snake_speed = 0.5
	elif index == 3:
		snake_speed = 0.25
	else:
		snake_speed = 0.1
