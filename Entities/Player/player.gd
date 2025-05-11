extends CharacterBody2D

@export var speed: int = 50
@export_range(1, 4) var speed_multiplier: int = 2
@export_range(0, 1e20) var max_stamina: int = 300
@export var stamina_time: float = 3.0
@export var stamina_gain: float = 1.0

@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _stamina_timer: Timer = $StaminaTimer
@onready var _progress_bar: ProgressBar = $Camera2D/ProgressBar

var _cur_dir: Vector2 = Vector2(1, 0) # -1 is left and 1 is right, y is 0
var _cur_stamina = self.max_stamina
var _gain_stamina = true

func _movement() -> void:
	var dir: Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
	self.velocity = dir * self.speed
	
	if self._cur_stamina > 0 and self.velocity != Vector2.ZERO and Input.is_action_pressed("Sprint"):
		self.velocity *= self.speed_multiplier
		
		if self._gain_stamina:
			self._gain_stamina = false
			self._stamina_timer.stop()
		
		self._cur_stamina -= 1
	elif self._cur_stamina < self.max_stamina and self._gain_stamina:
		self._cur_stamina += 1
	elif self._stamina_timer.is_stopped():
		self._stamina_timer.start(self.stamina_time)

func _animation() -> void:
	if self.velocity.x != 0:
		self._cur_dir.x = sign(self.velocity.x)
	
	self._animation_tree.set("parameters/Idle/blend_position", self._cur_dir)

func _on_stamina_timer_timeout() -> void:
	self._gain_stamina = true

func _ready() -> void:
	self._progress_bar.max_value = self.max_stamina

func _physics_process(delta: float) -> void:
	self._movement()
	self._animation()
	self._progress_bar.value = self._cur_stamina
	self.move_and_slide()
