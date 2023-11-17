class_name spawn extends Node3D

var occupied : bool = false

#func _process(delta):
#	if $Area3D.has_overlapping_areas():
#		occupied = true
#	if !($Area3D.has_overlapping_areas()):
#		occupied = false

func _on_area_3d_body_entered(body):
	occupied = true
	
func _on_area_3d_body_exited(body):
	occupied = false
