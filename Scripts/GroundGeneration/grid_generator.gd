class_name grid_generator extends Node3D

#--------------------Variables--------------------
@onready var ground_tile = preload("res://Scenes/GroundGeneration/ground_tile.tscn")
var new_tile

var grid_size = 8

@onready var spawn_point = preload("res://Scenes/spawn_point.tscn")
@onready var spawn_points = []
var new_spawn_point

#--------------------Logic--------------------
func _instantiate_ground():

	@warning_ignore("integer_division")
	var grid_calc = grid_size/2
	var start_point = Vector3(-2*grid_calc+1, 0, -2*grid_calc-1)
	var current_position = start_point
	
	#Initialize 2D array of grid size x grid size
	var floor_grid = []
	floor_grid.resize(grid_size)
	for i in grid_size:
		var temp = []
		temp.resize(grid_size)
		floor_grid[i] = temp
	
	#Iterate through 3D space and instantiates grid tiles at current position, filling 2D array, and creating 3D markers for spawn point array.
	for i in grid_size:
		current_position.z += 2
		for j in floor_grid[i]:

			new_tile = ground_tile.instantiate()
			new_tile.position = current_position
			$GroundTiles.add_child(new_tile)

			new_spawn_point = spawn_point.instantiate()
			new_spawn_point.position = Vector3(current_position.x, 1, current_position.z)
			spawn_points.append(new_spawn_point)
			$SpawnPoints.add_child(new_spawn_point)

			current_position.x += 2
			if current_position.x >= start_point.x + 2*grid_size:
				current_position.x -= 2*grid_size

