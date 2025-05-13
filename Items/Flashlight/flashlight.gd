extends Item

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _collisionShape: CollisionShape2D = $CollisionShape2D
@onready var _pointlight: PointLight2D = $PointLight2D

var _cur_dir: Vector2 = Vector2(1, 0) # -1 is left and 1 is right, y is 0

func _physics_process(delta: float) -> void:
	if self.get_parent().name.substr(0, 6) == "Player":
		var parent: CharacterBody2D = self.get_parent()
		
		self._collisionShape.disabled = true
		
		if self._cur_dir != parent._cur_dir:
			self._cur_dir = parent._cur_dir
			
			self._pointlight.position = -self._pointlight.position
			
			if parent._cur_dir.x > 0:
				self._sprite.flip_h = false
				self._sprite.position.x += 4
			elif parent._cur_dir.x < 0:
				self._sprite.flip_h = true
				self._sprite.position.x -= 4
	else:
		self._collisionShape.disabled = false
