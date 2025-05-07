class_name AbstractEnemy extends CharacterBody2D

@export var speed: int = 50
@export_range(1, 4) var speed_multiplier: int = 2

var _cur_dir: Vector2 = Vector2(1, 0) # -1 is left and 1 is right, y is 0

func wander() -> void:
	pass

func chase() -> void:
	pass

func attack() -> void:
	pass
