class_name tail extends CharacterBody3D

#--------------------Variables--------------------
var next_position
var direction

#--------------------Behaviour--------------------
#Converts a decimal percentage to a vector 3 equal in all three axis.
#Reduce scale of tail segment.
func _shrink(decimal_percentage):
	set_scale(into_vector(decimal_percentage))

#Updates position to next position.
func _move():
	global_position = next_position

#--------------------Helper--------------------
func into_vector(int_percentage):
	return Vector3(int_percentage, int_percentage, int_percentage)
