class_name blood extends Node3D

#Blood automatically deletes itself after the animation has had time to play.
func _ready():
	$Timer.start()

func _on_timer_timeout():
	queue_free()
