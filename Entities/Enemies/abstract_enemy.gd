class_name AbstractEnemy extends CharacterBody2D

@export var speed: int = 50

func wander() -> void:
	pass

func chase() -> void:
	pass

func attack() -> void:
	assert(false, "Method attack() should be implmented in the child node")
