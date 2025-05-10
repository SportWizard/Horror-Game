extends CharacterBody2D

@export var speed: int = 50
@export_range(1, 4) var speed_multiplier: int = 2

var _cur_dir: Vector2 = Vector2(1, 0) # -1 is left and 1 is right, y is 0

func _movement() -> void:
	var dir: Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
	self.velocity = dir * self.speed
	
	# If the player press sprint, it will 2 times the walking speed
	if Input.is_action_pressed("Sprint"):
		self.velocity *= self.speed_multiplier

func _animation() -> void:
	if self.velocity.x != 0:
		self._cur_dir.x = sign(self.velocity.x)
	
	$AnimationTree.set("parameters/Idle/blend_position", self._cur_dir)

func _physics_process(delta: float) -> void:
	self._movement()
	self._animation()
	self.move_and_slide()
