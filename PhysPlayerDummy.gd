extends Spatial

func setBodyPosition(position):
	$body.global_transform.origin = position
	
func getBodyPosition():
	return $body.global_transform.origin
	
func setBodyAngle(ang):
	$body.rotation = ang

func getBodyAngle():
	return $body.rotation
	
