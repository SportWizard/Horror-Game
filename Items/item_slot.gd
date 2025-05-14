extends Sprite2D

@onready var _player: CharacterBody2D = self.get_parent().get_parent()
@onready var _texture_rect: TextureRect = $TextureRect

func _physics_process(delta: float) -> void:
	if self._player.name.substr(0, 6) == "Player" and self._player._selected_item_slot == int(self.name.substr(8)):
		self.frame = 1
		
		var item: Item = self._player._item_slots[self._player._selected_item_slot-1]
		
		# Put image of the item in the slot
		if item:
			self._texture_rect.texture = item.get_node("Sprite2D").texture
		else:
			self._texture_rect.texture = null
	else:
		self.frame = 0
