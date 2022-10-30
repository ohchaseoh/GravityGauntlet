extends Spatial

func _move_cam(p1_pos, p2_pos):
	
	# camera look at center point
	var avg_pos = (p1_pos + p2_pos) / 2
	$Camera.look_at(avg_pos, Vector3.UP)
	
	# calculates the distance needed
	$Camera.translation.z = p1_pos.distance_to(p2_pos)*1.2
	if $Camera.translation.z < 3:
		$Camera.translation.z = 3
