extends Node3D

#--------------------Variables--------------------
@onready var camera = $World/CanvasLayer/SubViewportContainer/SubViewport/Camera3D

@onready var ground = $GridGenerator
@onready var food_spawner = $FoodSpawner
@onready var snake_head = preload("res://Scenes/Snake/head.tscn")

var snake_speed = 0.5
var grid_size
var grid_label = "Normal"
var speed_label = "Normal"

var game_over : bool = false
var game_won

signal main_menu_pressed

#--------------------Classic Snake Initialization and Reset--------------------
func _ready():
	grid_size = ground.grid_size
	$World/CanvasLayer/PauseMenu.visible = false
	$World/CanvasLayer/DeathMenu.visible = false
	$World/CanvasLayer/WinMenu.visible = false
	
func _begin():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	ground._instantiate_ground()
	instantiate_head()
	food_spawner.spawn_points = ground.spawn_points
	food_spawner.spawning = true
	
	$World/CanvasLayer/PreGameMenu.visible = false
	var controls_tip = load("res://Scenes/UI/controls_tip.tscn")
	var new_controls_tip = controls_tip.instantiate()
	$World/CanvasLayer/SubViewportContainer/SubViewport.add_child(new_controls_tip)
	
func instantiate_head():
	snake_head = snake_head.instantiate()
	snake_head.position = Vector3(1,1,1)
	snake_head.current_direction = "up"
	$Snake.add_child(snake_head)
	snake_head.connect("snake_death", _on_snake_death, 0)
	snake_head.connect("snake_win", _on_snake_won, 0)
	snake_head._set_bounds(ground.grid_size)
	snake_head.move_timer.set_wait_time(snake_speed)

func restart():
	game_over = false
	food_spawner.spawning = true
	$World/CanvasLayer/DeathMenu.visible = false
	instantiate_head()

#--------------------Menu Logic--------------------
#Pregame settings and start button
func _on_begin_pressed():
	_begin()

func _on_map_size_item_selected(index):
	match index:
		0:
			ground.grid_size = 6 
			camera.global_position = Vector3(0,10,0)
			grid_label = "Small"
		1:
			ground.grid_size = 8
			camera.global_position = Vector3(0,14,0)
			grid_label = "Normal"
		2:
			ground.grid_size = 16
			camera.global_position = Vector3(0,25,0)
			grid_label = "Large"
	
func _on_snake_speed_item_selected(index):
	match index:
		0:
			snake_speed = 1
			speed_label = "Slowest"
		1:
			snake_speed = .75
			speed_label = "Slow"
		2:
			snake_speed = 0.5
			speed_label = "Normal"
		3:
			snake_speed = 0.25
			speed_label = "Fast"
		_:
			snake_speed = 0.175
			speed_label = "Fastest"

#Pause on "Escape" while snake is alive
func _input(event):
	if(event.is_action_released("Escape") and snake_head and !game_over and !game_won):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		$World/CanvasLayer/PauseMenu.visible = true

#Unpause
func _on_continue_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	$World/CanvasLayer/PauseMenu.visible = false

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")

func _on_quit_game_pressed():
	get_tree().quit()
	
func _on_restart_pressed():
	if(game_won and snake_head):
		game_won = false
		$World/CanvasLayer/WinMenu.visible = true
		snake_head.delete_tail()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	snake_head = load("res://Scenes/Snake/head.tscn")
	restart()

func _on_snake_death(length):
	food_spawner.spawning = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$World/CanvasLayer/DeathMenu/VBoxContainer/FinalSnakeLength.text = ("Final Snake Length: " + str(length))
	$World/CanvasLayer/DeathMenu.visible = true
	game_over = true

func _on_snake_won(length):
	food_spawner.spawning = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$World/CanvasLayer/WinMenu/VBoxContainer/Description.text = ("Final Snake Length: " + str(length) + " - You won on -" + str(speed_label) + "- speed and -" + str(grid_label) + "- map size!")
	$World/CanvasLayer/WinMenu.visible = true
	game_won = true

# ("Final Snake Length: " + str(grid_size**2) + "You won on " + str(snake_speed) + " speed and " + str(grid_label) + " map size!")
