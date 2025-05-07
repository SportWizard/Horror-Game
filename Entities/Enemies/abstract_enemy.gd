class_name AbstractEnemy extends CharacterBody2D

@export var speed: int = 50
@export_range(1, 4) var speed_multiplier: int = 2
@export var wander_timer: float = 3.0

var _cur_dir: Vector2 = Vector2(1, 0) # -1 is left and 1 is right, y is 0
var _dirs: Array[Vector2] = [Vector2.ZERO, Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)] # Rest, left, right, up, down

func wander() -> void:
	var dir: Vector2 = self._dirs[randi() % self._dirs.size()]
	self.velocity = dir * self.speed
	
	# Animations
	self._cur_dir.x = self._cur_dir.x if Helper.same_axis_dir(self._cur_dir.x, velocity.x) else -self._cur_dir.x
	$AnimationTree.set("parameters/Idle/blend_position", self._cur_dir)

func chase() -> void:
	pass

func attack() -> void:
	pass
