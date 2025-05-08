class_name Enemy extends CharacterBody2D

@export var speed: int = 50
@export_range(1, 4) var speed_multiplier: int = 2
@export var wander_timer: float = 3.0

var _cur_dir: Vector2 = Vector2(1, 0) # -1 is left and 1 is right, y is 0
var _dirs: Array[Vector2] = [Vector2.ZERO, Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)] # Rest, left, right, up, down

func _wander() -> void:
	var dir: Vector2 = self._dirs[randi() % self._dirs.size()]
	self.velocity = dir * self.speed
	
	# Animations
	self._cur_dir.x = self._cur_dir.x if Helper.same_axis_dir(self._cur_dir.x, velocity.x) else -self._cur_dir.x
	$AnimationTree.set("parameters/Idle/blend_position", self._cur_dir)

func _chase() -> void:
	pass

func _attack() -> void:
	pass

func _on_wander_timer_timeout() -> void:
	self._wander()

func _on_structure_detection_body_entered(body: Node2D) -> void:
	self._wander()
	
	# Reset timer
	$WanderTimer.start(self.wander_timer)

func _on_player_detection_body_entered(body: Node2D) -> void:
	print(body.position)

func _ready() -> void:
	# Check if nodes exists and connection with signals
	if not $WanderTimer:
		assert(false, "Change \"Timer\" to \"WanderTimer\"")
	if not $WanderTimer.is_connected("timeout", Callable(self, "_on_wander_timer_timeout")):
		assert(false, "Missing connection between WanderTimer and _on_wander_timer_timeout()")
	
	if not $StructureDetection:
		assert(false, "Change \"Area2D\" to \"StructureDetection\"")
	if not $StructureDetection.is_connected("body_entered", Callable(self, "_on_structure_detection_body_entered")):
		assert(false, "Missing connection between StructureDetection and _on_structure_detection_body_entered()")
	
	if not $PlayerDetection:
		assert(false, "Change \"Area2D\" to \"PlayerDetection\"")
	if not $PlayerDetection.is_connected("body_entered", Callable(self, "_on_player_detection_body_entered")):
		assert(false, "Missing connection between PlayerDetection and _on_player_detection_body_entered()")

func _physics_process(delta: float) -> void:
	# Start the timer for wander
	if $WanderTimer.is_stopped():
		$WanderTimer.start(self.wander_timer)
	
	self.move_and_slide()
