class_name Item extends CharacterBody2D

@export var item_offset: Vector2 = Vector2(0, 0)

func use():
	assert(false, "Add function \"use\" to %s" % [self.name])
