extends CharacterBody2D

@export var speed: int = 50
@export_range(1, 4) var speed_multiplier: int = 2
@export_range(0, 1e20) var max_stamina: int = 300
@export var stamina_time: float = 3.0
@export var stamina_gain: float = 1.0

@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _state_machine: AnimationNodeStateMachinePlayback = self._animation_tree["parameters/playback"]
@onready var _stamina_timer: Timer = $StaminaTimer
@onready var _progress_bar: ProgressBar = $UI/ProgressBar
@onready var _player_inventory: TextureRect = $UI/PlayerInventory

var _cur_dir: Vector2 = Vector2(1, 0) # -1 is left and 1 is right, y is 0

var _cur_stamina = self.max_stamina
var _gain_stamina = true

var _detected_item: Item = null
var _selected_item_slot: int = 1
var _item_slots: Array[Item] = [null, null]

func _animation() -> void:
	if self.velocity.x != 0:
		self._cur_dir.x = sign(self.velocity.x)
	
	if self.velocity == Vector2.ZERO:
		self._state_machine.travel("Idle")
		self._animation_tree.set("parameters/Idle/blend_position", self._cur_dir)
	elif abs(self.velocity.x) <= self.speed and abs(self.velocity.y) <= self.speed:
		self._state_machine.travel("Move")
		self._animation_tree.set("parameters/Move/blend_position", self._cur_dir)
	else:
		self._state_machine.travel("Run")
		self._animation_tree.set("parameters/Run/blend_position", self._cur_dir)

func _movement(dir: Vector2) -> void:
	self.velocity = dir * self.speed
	
	self._progress_bar.value = self._cur_stamina
	
	if self._cur_stamina > 0 and self.velocity != Vector2.ZERO and Input.is_action_pressed("Sprint"):
		self.velocity = dir * self.speed * self.speed_multiplier
		
		if self._gain_stamina:
			self._gain_stamina = false
			self._stamina_timer.stop()
		
		self._cur_stamina -= 1
	elif self._cur_stamina < self.max_stamina and self._gain_stamina:
		self._cur_stamina += 1
	elif self._stamina_timer.is_stopped():
		self._stamina_timer.start(self.stamina_time)

func _on_stamina_timer_timeout() -> void:
	self._gain_stamina = true

func _on_item_detector_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Item):
		var item: Item = body
		self._detected_item = item

func _on_item_detector_body_exited(body: Node2D) -> void:
	if is_instance_of(body, Item):
		var item: Item = body
		
		if item == self._detected_item:
			self._detected_item = null

func _pickup_item() -> void:
	var item: Item = self._detected_item
	self._detected_item.get_parent().remove_child(item)
	self.add_child(item)
	item.global_position = self.global_position + item.item_offset # Reset position
	
	self._item_slots[self._selected_item_slot-1] = item

func _drop_item() -> void:
	var item: Item = self._item_slots[self._selected_item_slot-1]
	self.remove_child(item)
	self.get_parent().add_child(item)
	item.global_position = self.global_position + item.item_offset # Reset position
	
	self._item_slots[self._selected_item_slot-1] = null

func _user_input() -> void:
	var dir: Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
	self._movement(dir)
	
	if Input.is_action_pressed("Interact"):
		if self._detected_item:
			self._pickup_item()
	
	if Input.is_action_pressed("Drop item"):
		if self._item_slots[self._selected_item_slot-1]:
			self._drop_item()
	
	if Input.is_action_pressed("Item slot1"):
		self._selected_item_slot = 1
	elif Input.is_action_pressed("Item slot2"):
		self._selected_item_slot = 2

func _ready() -> void:
	self._progress_bar.max_value = self.max_stamina

func _physics_process(delta: float) -> void:
	self._user_input()
	self._animation()
	self.move_and_slide()
