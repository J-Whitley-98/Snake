extends Node3D

@onready var food_rat = preload("res://Scenes/FoodGeneration/food.tscn")
@onready var food_spawn_timer = $SpawnTimer

@onready var blood = preload("res://Scenes/FoodGeneration/blood.tscn")

var food_count = 0
var new_food
var spawn_points : Array = []

var random_id

var valid_spawn

#func random_spawn():
#	var snake_positions = get_node("../Snake").get_child(0).positions
#	random_id = randi() % (spawn_points.size() + 1)
#	while array_contains(snake_positions, valid_spawn):
#		valid_spawn = spawn_points[random_id-1].position
#	return valid_spawn
	
func array_contains(array, search):
	var yes : bool = false
	for value in array:
		if search == value:
			yes = false
	return yes

func random_spawn_point():
	var snake_positions = get_node("../Snake").get_child(0).positions
	random_id = randi() % (spawn_points.size() + 1)
	var point_found : bool = false
	while(snake_positions.has(spawn_points[random_id-1].position)):
		random_id = randi() % (spawn_points.size() + 1)
	return spawn_points[random_id-1].position

func _on_spawn_timer_timeout():
	var random_int = randi() % 5
	if food_count < 2:
		new_food = food_rat.instantiate()
		new_food.position = random_spawn_point()
		new_food.rotation = Vector3(0,90,0)*random_int
		get_tree().current_scene.add_child(new_food)
		new_food.connect("eaten", Callable(self, "_food_eaten"), 0)
		food_count += 1
		
func _food_eaten():
	food_count -=1
