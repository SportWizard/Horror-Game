class_name Enemy extends CharacterBody2D

@export var speed: float = 50
@export_range(1, 4) var speed_multiplier: float = 2
@export var wander_time: float = 3.0
@export var reaction_time: float = 0.25

var _cur_dir: Vector2 = Vector2(1, 0) # -1 is left and 1 is right, y is 0
var _dirs: Array[Vector2] = [Vector2.ZERO, Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)] # Rest, left, right, up, down
var _chasing: Node2D = null

func _animation() -> void:
	self._cur_dir.x = self._cur_dir.x if Helper.same_axis_dir(self._cur_dir.x, velocity.x) else -self._cur_dir.x
	$AnimationTree.set("parameters/Idle/blend_position", self._cur_dir)

func _wander() -> void:
	var dir: Vector2 = self._dirs[randi() % self._dirs.size()]
	self.velocity = dir * self.speed

func _chase() -> void:
	if self._chasing != null:
		var dir: Vector2 = (self._chasing.position - self.position).normalized()
		self.velocity = dir * self.speed * self.speed_multiplier

func _attack() -> void:
	pass

func _on_wander_timer_timeout() -> void:
	self._wander()

func _on_structure_detection_body_entered(body: Node2D) -> void:
	self._wander()
	# Reset timer
	$WanderTimer.start(self.wander_timer)

func _on_player_detection_body_entered(body: Node2D) -> void:
	self._chasing = body
	$WanderTimer.stop()
	self._chase()

func _on_reaction_timer_timeout() -> void:
	self._chase()

func _on_chase_zone_body_exited(body: Node2D):
	self._chasing = null

func _check_node_and_connection(node: Node, node_name: String, node_type: String, connection_name: String, function_name: String):
	if not node:
		assert(false, "Change node \"%s\" to \"%s\" for \"%s\"" % [node_type, node_name, self.name])
	if not node.is_connected(connection_name, Callable(self, function_name)):
		assert(false, "Missing connection between \"%s\"'s \"%s\" and \"%s\" for \"%s\"" % [node_name, connection_name, function_name, self.name])

func _ready() -> void:
	self._check_node_and_connection($WanderTimer, "WanderTimer", "Timer", "timeout", "_on_wander_timer_timeout")
	self._check_node_and_connection($ReactionTimer, "ReactionTimer", "Timer", "timeout", "_on_reaction_timer_timeout")
	self._check_node_and_connection($StructureDetection, "StructureDetection", "Area2D", "body_entered", "_on_structure_detection_body_entered")
	self._check_node_and_connection($PlayerDetection, "PlayerDetection", "Area2D", "body_entered", "_on_player_detection_body_entered")
	self._check_node_and_connection($ChaseZone, "ChaseZone", "Area2D", "body_exited", "_on_chase_zone_body_exited")

func _physics_process(delta: float) -> void:
	if self._chasing and $ReactionTimer.is_stopped():
		$ReactionTimer.start(self.reaction_time)
	
	# Start the timer for wander
	elif $WanderTimer.is_stopped():
		$WanderTimer.start(self.wander_time)
	
	self.move_and_slide()
	self._animation()
