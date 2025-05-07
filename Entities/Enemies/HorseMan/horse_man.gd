extends Enemy

func _on_timer_timeout() -> void:
	self.wander()

func _on_structure_detection_body_entered(body: Node2D) -> void:
	self.wander()
	
	# Reset timer
	$Timer.start(self.wander_timer)

func _physics_process(delta: float) -> void:
	# Start the timer for wander
	if $Timer.is_stopped():
		$Timer.start(self.wander_timer)
	
	self.move_and_slide()
