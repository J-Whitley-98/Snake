extends Node3D

@onready var food_rat = preload("res://Scenes/FoodGeneration/food.tscn")
@onready var blood = preload("res://Scenes/FoodGeneration/blood.tscn")

var max_food = 2
var food_count = 0
var new_food
var spawn_points : Array = []
var available_spawn_points = []
var snake_positions
var food_positions = []

var grid_size

var random_id

var spawning : bool = false

@onready var snake = get_node("../Snake")

func _process(_delta):
	if (food_count < max_food and spawning):
		snake_positions = snake.get_child(0).positions
		var random_int = randi() % 5
		new_food = food_rat.instantiate()
		new_food.position = random_spawn_point()
		if new_food.position == Vector3(999,999,999):
			spawning = false
			return
		new_food.rotation = Vector3(0,45,0)*random_int # Not sure if this is the best way to do this random rotation
		add_child(new_food)
		new_food.connect("eaten", _food_eaten, 0)
		food_count += 1

#func calculate_snake_positions():
#	snake_positions.clear()
#	for snake_part in snake.get_children():
#		snake_positions.append(snake_part.global_position)

#func random_spawn_point():
#	calculate_snake_positions()
#	random_id = randi() % (spawn_points.size() + 1)
#	while(snake_positions.has(spawn_points[random_id-1].position)):
#		random_id = randi() % (spawn_points.size() + 1)
#		calculate_snake_positions()
#	return spawn_points[random_id-1].position
	
func random_spawn_point():
	available_spawn_points.clear()
	for spawn_point in spawn_points:
		if spawn_point.occupied == false:
			available_spawn_points.append(spawn_point)
	if available_spawn_points.size() == 0:
		return Vector3(999,999,999)
	else:
		random_id = randi() % (available_spawn_points.size() + 1)
		return available_spawn_points[random_id-1].position
	
func _food_eaten():
	food_count -=1
	
