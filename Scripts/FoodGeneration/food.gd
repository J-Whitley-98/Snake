class_name food extends Node3D

@onready var blood = preload("res://Scenes/FoodGeneration/blood.tscn")
@onready var food_spawner = load("res://Scenes/FoodGeneration/food_spawner.tscn")

signal eaten()

#If snake collides with prey, prey deletes itself and instantiates blood effect in main scene.
func _explode():
	eaten.emit()
	var new_blood = blood.instantiate()
	new_blood.position = global_position
	get_tree().current_scene.add_child(new_blood)
	new_blood.get_child(0).restart()
	new_blood.get_child(0).emitting = true
	queue_free()
