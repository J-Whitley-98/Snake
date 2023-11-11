class_name blood extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()


func _on_timer_timeout():
	queue_free()
