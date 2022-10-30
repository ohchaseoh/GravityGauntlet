extends Camera

func _move_cam(p1_pos, p2_pos):
	
	# camera look at center point
	var avg_pos = (p1_pos + p2_pos) / 2
	self.look_at(avg_pos, Vector3.UP)
	
	# calculates the distance needed
	self.translation.z = p1_pos.distance_to(p2_pos)*2.1
	if self.translation.z < 3:
		self.translation.z = 3


func _on_Main_player_pos(p1_pos, p2_pos):
	_move_cam(p1_pos,p2_pos)
