extends Node3D

@onready var food_rat = preload("res://Scenes/FoodGeneration/food.tscn")
@onready var food_spawn_timer = $SpawnTimer

@onready var blood = preload("res://Scenes/FoodGeneration/blood.tscn")

var food_count = 0
var new_food
var spawn_points : Array = []

var grid_size

var random_id

var snake_positions

func calculate_snake_positions():
	var snake = get_node("../Snake")
	var snake_parts = snake.get_children()
	snake_positions = []
	for part in snake_parts:
		snake_positions.append(part.global_position)
	

func random_spawn_point():
	calculate_snake_positions()
	random_id = randi() % (spawn_points.size() + 1)
	while(snake_positions.has(spawn_points[random_id-1].position)):
		random_id = randi() % (spawn_points.size() + 1)
		calculate_snake_positions()
	return spawn_points[random_id-1].position

func _on_spawn_timer_timeout():
	var random_int = randi() % 5
	if (food_count < 2):
		new_food = food_rat.instantiate()
		new_food.position = random_spawn_point()
		new_food.rotation = Vector3(0,90,0)*random_int
		get_tree().current_scene.add_child(new_food)
		new_food.connect("eaten", _food_eaten, 0)
		food_count += 1
		
func _food_eaten():
	food_count -=1
