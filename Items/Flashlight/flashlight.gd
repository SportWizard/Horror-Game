extends Item

@onready var _collisionShape: CollisionShape2D = $CollisionShape2D

var _cur_dir: Vector2 = Vector2(1, 0)

func _physics_process(delta: float) -> void:
	if self.get_parent().name.substr(0, 6) == "Player":
		var player_vel: Vector2 = self.get_parent().velocity
		
		self._collisionShape.disabled = true
		
		self._cur_dir = Vector2(sign(player_vel.x), sign(player_vel.y))
		
		# Point in the direction of the player
		if (self._cur_dir.x > 0 and self.scale.x < 0) or (self._cur_dir.x < 0 and self.scale.x > 0):
			self.scale.x = -self.scale.x
		
		if player_vel.x != 0 and player_vel.y != 0:
			if player_vel.y < 0:
				self.rotation_degrees = -45 if self.scale.x > 0 else 45
			elif player_vel.y > 0:
				self.rotation_degrees = -45 if self.scale.x < 0 else 45
		elif player_vel.x != 0:
			self.rotation_degrees = 0
		else:
			if player_vel.y < 0:
				self.rotation_degrees = -90 if self.scale.x > 0 else 90
			elif player_vel.y > 0:
				self.rotation_degrees = -90 if self.scale.x < 0 else 90
			
	else:
		self._collisionShape.disabled = false
