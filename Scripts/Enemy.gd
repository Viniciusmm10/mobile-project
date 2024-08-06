extends CharacterBody3D

var health = 100

func _ready() -> void:
	add_to_group("Enemies")
	
func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()
