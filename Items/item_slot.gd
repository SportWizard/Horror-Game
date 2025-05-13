extends Control

@onready var _player: CharacterBody2D = self.get_parent().get_parent()
@onready var _sprite: Sprite2D = $Sprite2D
@onready var _texture_rect: TextureRect = $TextureRect

func _physics_process(delta: float) -> void:
	if self._player.name.substr(0, 6) == "Player" and self._player._selected_item_slot == int(self.name.substr(8)):
		self._sprite.frame = 1
		
		var item: Item = self._player._item_slots[self._player._selected_item_slot-1]
		
		if item:
			self._texture_rect.texture = item.get_node("Sprite2D").texture
	else:
		self._sprite.frame = 0
