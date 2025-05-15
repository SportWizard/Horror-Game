extends Item

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _point_light: PointLight2D = $PointLight2D

# Override
func use():
	self._point_light.visible = false if self._point_light.visible else true 

func _physics_process(delta: float) -> void:
	if self.get_parent().name.substr(0, 6) == "Player":
		self._collision_shape.disabled = true
		
		self.look_at(self.get_global_mouse_position())
	else:
		self._collision_shape.disabled = false
