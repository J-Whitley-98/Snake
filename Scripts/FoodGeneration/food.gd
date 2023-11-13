class_name food extends CharacterBody3D

#-------------------------Variables & Signals--------------------
@onready var blood = preload("res://Scenes/FoodGeneration/blood.tscn")
@onready var food_spawner = preload("res://Scenes/FoodGeneration/food_spawner.tscn")

var new_blood

signal eaten()

#--------------------Logic--------------------
#If snake collides with food, food deletes itself and instantiates blood effect in main scene.
func _explode():
	eaten.emit()
	new_blood = blood.instantiate()
	new_blood.position = global_position
	get_tree().current_scene.add_child(new_blood)
	new_blood.get_child(0).restart()
	new_blood.get_child(0).emitting = true
	queue_free()
	

