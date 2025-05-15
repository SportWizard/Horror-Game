extends Item

@onready var _collisionShape: CollisionShape2D = $CollisionShape2D

var _cur_dir: Vector2 = Vector2(1, 0)

func _physics_process(delta: float) -> void:
	if self.get_parent().name.substr(0, 6) == "Player":
		self._collisionShape.disabled = true
		
		self.look_at(self.get_global_mouse_position())
	else:
		self._collisionShape.disabled = false
