class_name Helper extends Node

static func same_x_dir(prev_x_dir: int, velocity_x: int) -> bool:
	if prev_x_dir != -1 && prev_x_dir != 1:
		assert(false, "prev_x_dir must be either -1 or 1")
	
	if velocity_x == 0:
		return true

	var cur_dir: int = 0
	
	if velocity_x > 0:
		cur_dir = 1
	elif velocity_x < 0:
		cur_dir = -1
	
	return prev_x_dir == cur_dir
