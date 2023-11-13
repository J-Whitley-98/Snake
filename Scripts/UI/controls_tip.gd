extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	$AnimationPlayer.play("pulse")

func _on_timer_timeout():
	queue_free()
