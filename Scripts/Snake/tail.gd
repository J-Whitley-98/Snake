class_name tail extends CharacterBody3D

#Stores next move, first tail segment's next position is the head's position.
var next_position
#This is a flag for checking a weird collision case
var direction

#Converts a decimal percentage to a vector 3 equal in all three axis.
func into_vector(int_percentage):
	return Vector3(int_percentage, int_percentage, int_percentage)

#Reduce scale of tail segment.
func _shrink(decimal_percentage):
	set_scale(into_vector(decimal_percentage))

#Updates position to next position.
func _move():
	global_position = next_position


