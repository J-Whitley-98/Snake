class_name head extends CharacterBody3D

@onready var tail_segment = preload("res://Scenes/Snake/tail.tscn")

signal snake_death(snake_length)

@onready var move_timer = $Timer

var game_over : bool = false
var new_tail_segment

#--------------------------------------------VARIABLES----------------------------------------------
var snake_length 

#Initialize initial direction as up and head starting position x and y.
var last_direction = Vector2(0,1)
@onready var head_pos = Vector2(global_position.x,global_position.z)
var forward

#Initialize boundary and tail segment array.
var bounds = 0
var tail_segments = []

var positions = []
#---------------------------------------------------------------------------------------------------

func _ready():
	#food_eaten_signal.connect() - connect this to the food spawner in the classic snake 
	instantiate_tail()
	move_timer.start()

#--------------------------------------------PROCESS------------------------------------------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#If game over due to out of bounds or tail collision, game over breaks the process loop
	if game_over:
		return
	
	#If player goes out of bounds, deletes head, which triggers tail deletion.
	if(head_pos.x > bounds or head_pos.y > bounds or head_pos.x < -bounds or head_pos.y < -bounds):
		game_over = true
		move_timer.stop()
		await delete_tail()
		queue_free()
		
#	Makes the last tail segment like 1/2 size
#	This also reminds me of a bug or visual problem - new tail segments are always full size on screen
#	on instantiation. Fix by startings small or invisible?
#	last_array_entry(tail_segments)._shrink(1-(.5))

func _on_area_3d_body_entered(body):
	if ((body is tail) and (body != last_array_entry(tail_segments))):
		game_over = true
		move_timer.stop()
		await delete_tail()
		queue_free()

	if body is food:
		body._explode()
		food_eaten()
#---------------------------------------------------------------------------------------------------

#--------------------------------------------SETTERS & HELPERS--------------------------------------
#Setter for floor bounds to allow internal "out of bounds" checks.
func _set_bounds(grid_size):
	bounds = grid_size/2

func last_array_entry(array):
	return array[array.size()-1]
#---------------------------------------------------------------------------------------------------

#----------------------------------------MOVEMENT---------------------------------------------------
func _input(event):
	if(event.is_action_released("Up") and last_direction != Vector2(0,-1) and forward != "down"):
		last_direction = Vector2(0,1)
	if(event.is_action_released("Down") and last_direction != Vector2(0,1) and forward != "up"):
		last_direction = Vector2(0,-1)
	if(event.is_action_released("Right") and last_direction != Vector2(-1,0) and forward != "left"):
		last_direction = Vector2(1,0)
	if(event.is_action_released("Left") and last_direction != Vector2(1,0) and forward != "right"):
		last_direction = Vector2(-1,0)

func _on_timer_timeout():
	if last_direction == Vector2(0,1):
		global_position = (global_position + Vector3(0,0,-2))
		head_pos.y += 1
		forward = "up"
		look_at((global_position + Vector3(0,0,2)), Vector3.UP)
	if last_direction == Vector2(0,-1):
		global_position = (global_position + Vector3(0,0,2))
		head_pos.y -= 1
		forward = "down"
		look_at((global_position + Vector3(0,0,-2)), Vector3.UP)
	if last_direction == Vector2(1,0):
		global_position = (global_position + Vector3(2,0,0))
		head_pos.x += 1
		forward = "right"
		look_at((global_position + Vector3(-2,0,0)), Vector3.UP)
	if last_direction == Vector2(-1,0):
		global_position = (global_position + Vector3(-2,0,0))
		head_pos.x -= 1
		forward = "left"
		look_at((global_position + Vector3(2,0,0)), Vector3.UP)
	update_tail()
#---------------------------------------------------------------------------------------------------

#---------------------------------TAIL--------------------------------------------------------------
func instantiate_tail():
	generate_new_tail_segment(Vector3(0,1,2), get_tree().current_scene)
	tail_segments[0].next_position = position
	
#Helper function for instantiating a tail block, I want this to be moved to the head?
func generate_new_tail_segment(position_init, parent_scene):
	new_tail_segment = tail_segment.instantiate()
	tail_segments.append(new_tail_segment)
	new_tail_segment.position = position_init
	new_tail_segment.next_position = position_init
	parent_scene.add_child(new_tail_segment)	

func food_eaten():
	var tail_end = last_array_entry(tail_segments)
	generate_new_tail_segment(tail_end.position, get_node("../"))

#Updates entire tail's position and size.
func update_tail():
	var shrink_percentage = 0.01
	snake_length = 1 + tail_segments.size()
	positions = []
	positions.append(global_position)
	
	for segment in tail_segments:
		positions.append(segment.global_position)
		segment._move()
	for index in tail_segments.size():
		if index == 0:
			tail_segments[index].next_position = global_position
		else:
			tail_segments[index].next_position = tail_segments[index-1].global_position
	for i in range(0,tail_segments.size()):
		tail_segments[i]._shrink(1-(shrink_percentage*i))
		
func delete_tail():
#	for i in range(0, tail_segments.size()):
#		await get_tree().create_timer(.1).timeout
#		tail_segments[tail_segments.size()-i-1].queue_free()
	for segment in tail_segments:
		segment.queue_free()
	snake_death.emit(snake_length)



