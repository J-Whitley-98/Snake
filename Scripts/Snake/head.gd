class_name head extends CharacterBody3D

#--------------------Variables & Signals--------------------
@onready var tail_segment = preload("res://Scenes/Snake/tail.tscn")

@onready var move_timer = $Timer

var game_over : bool = false
var game_won : bool = false

var new_tail_segment

var last_direction = Vector2(0,1)
var head_pos: Vector2 = Vector2(1,1)
var current_direction
var bounds = 0

var tail_segments = []
@onready var positions = [global_position, Vector3(0,1,2)]
var snake_length 
var tail_end

var jumping : bool = false

signal snake_death(snake_length)
signal snake_win(snake_length)

#---------------------------------------------------------------------------------------------------

func _ready():
	instantiate_tail()
	move_timer.start()

#--------------------------------------------PROCESS------------------------------------------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#If game over due to out of bounds or tail collision, game over breaks the process loop
	if game_over or game_won:
		return
	
	#If player goes out of bounds, deletes head, which triggers tail deletion.
	if(head_pos.x > bounds or head_pos.y > bounds or head_pos.x < -bounds or head_pos.y < -bounds):
		game_over = true
		move_timer.stop()
		delete_tail()
	
	if (snake_length == ((2*bounds)**2)):
		game_won = true
		snake_win.emit(snake_length)
		move_timer.stop()
		
func _on_area_3d_body_entered(body):
	if (!game_over and (body is tail) and (body != last_array_entry(tail_segments))):
		game_over = true
		move_timer.stop()
		delete_tail()

	if body is food:
		body._explode()
		food_eaten()

#--------------------------------------------Setters & Helpers--------------------------------------
#Allows internal "out of bounds" checks.
func _set_bounds(grid_size):
	bounds = grid_size/2

func last_array_entry(array):
	return array[array.size()-1]

#--------------------Movement--------------------
func _input(event):
	if(event.is_action_released("Up") and last_direction != Vector2(0,-1) and current_direction != "down"):
		last_direction = Vector2(0,1)
	if(event.is_action_released("Down") and last_direction != Vector2(0,1) and current_direction != "up"):
		last_direction = Vector2(0,-1)
	if(event.is_action_released("Right") and last_direction != Vector2(-1,0) and current_direction != "left"):
		last_direction = Vector2(1,0)
	if(event.is_action_released("Left") and last_direction != Vector2(1,0) and current_direction != "right"):
		last_direction = Vector2(-1,0)

func _on_timer_timeout():
	if last_direction == Vector2(0,1):
		global_position = (global_position + Vector3(0,0,-2))
		head_pos.y -= 1
		if head_pos.y == 0:
			head_pos.y -= 1
		current_direction = "up"
		look_at((global_position + Vector3(0,0,2)), Vector3.UP)
	if last_direction == Vector2(0,-1):
		global_position = (global_position + Vector3(0,0,2))
		head_pos.y += 1
		if head_pos.y == 0:	
			head_pos.y += 1
		current_direction = "down"
		look_at((global_position + Vector3(0,0,-2)), Vector3.UP)
	if last_direction == Vector2(1,0):
		global_position = (global_position + Vector3(2,0,0))
		head_pos.x += 1
		if head_pos.x == 0:
			head_pos.x += 1
		current_direction = "right"
		look_at((global_position + Vector3(-2,0,0)), Vector3.UP)
	if last_direction == Vector2(-1,0):
		global_position = (global_position + Vector3(-2,0,0))
		head_pos.x -= 1
		if head_pos.x == 0:
			head_pos.x -= 1
		current_direction = "left"
		look_at((global_position + Vector3(2,0,0)), Vector3.UP)
		
	update_tail()

#--------------------Tail Logic--------------------
func instantiate_tail():
	generate_new_tail_segment(Vector3(0,1,2), get_node("../"))
	tail_segments[0].next_position = position
	
func generate_new_tail_segment(position_init, parent_scene):
	new_tail_segment = tail_segment.instantiate()
	tail_segments.append(new_tail_segment)
	new_tail_segment.position = position_init
	new_tail_segment.next_position = position_init
	parent_scene.add_child(new_tail_segment)	
	new_tail_segment._shrink(0.01)

func food_eaten():
	tail_end = last_array_entry(tail_segments)
	generate_new_tail_segment(tail_end.position, get_node("../"))
	$Crunch.play()

#Updates entire tail's position and size.
func update_tail():
	var shrink_percentage = 0.01
	snake_length = 1 + tail_segments.size()
	positions.clear()
	positions.append(global_position)
	
	for segment in tail_segments:
		positions.append(segment.global_position)
		segment._move()
	for index in tail_segments.size():
		# First segment follows the snake head.
		if index == 0:
			tail_segments[index].next_position = global_position
		# Each subsequent tail segment follows the previous.
		else:
			tail_segments[index].next_position = tail_segments[index-1].global_position
	# Shrink all tail segments by 1% multiplied by their index in the tail.
	for i in range(0,tail_segments.size()):
		tail_segments[i]._shrink(1-(shrink_percentage*i))
		
func delete_tail():
#	for i in range(0, tail_segments.size()):
#		await get_tree().create_timer(.1).timeout
#		tail_segments[tail_segments.size()-i-1].queue_free()
	var tail_at_time = tail_segments.duplicate()
	tail_at_time.reverse()
	for segment in tail_segments:
		await get_tree().create_timer(.1).timeout
		segment.queue_free()
	snake_death.emit(snake_length)
	queue_free()





