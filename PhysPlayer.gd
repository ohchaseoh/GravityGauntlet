extends Spatial

func setBodyPosition(position):
	$body.global_transform.origin = position
	
func getBodyPosition():
	return $body.global_transform.origin
	
func setBodyAngle(ang):
	$body.rotation = ang

func getBodyAngle():
	return $body.rotation
	


func _on_HandRCollision_body_entered(body):
	body.get_owner().get_owner().getBall().add_central_force($hand_r.linear_velocity * 30)
	print("Hit")


func _on_HandLCollision_body_entered(body):
	body.get_owner().get_owner().getBall().add_central_force($hand_r.linear_velocity * 30)
