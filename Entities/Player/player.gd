extends CharacterBody2D

@export var speed: int = 200
@export_range(1, 4) var speed_multiplier: int = 2

var _cur_dir: int = 1 # -1 is left and 1 is right

func _movement() -> void:
	var dir: Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
	self.velocity = dir * speed
	
	# If the player press sprint, it will 2 times the walking speed
	if Input.is_action_pressed("Sprint"):
		self.velocity *= speed_multiplier
	
	# Animations
	self._cur_dir = self._cur_dir if Helper.same_x_dir(self._cur_dir, velocity.x) else -self._cur_dir
	$AnimationTree.set("parameters/Idle/blend_position", Vector2(self._cur_dir, 0))

func _physics_process(delta: float) -> void:
	self._movement()
	self.move_and_slide()
