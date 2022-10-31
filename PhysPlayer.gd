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
	punch_sound()
	print("Hit")

func _on_HandLCollision_body_entered(body):
	body.get_owner().get_owner().getBall().add_central_force($hand_r.linear_velocity * 30)
	punch_sound()
	print("Hit")
	
func punch_sound():
	
	var rand_punch = floor(rand_range(0, 3))
		
	match str(rand_punch):
		"0":
			$SFXPhysPlayer.stream = preload("res://assets/sfx/punch1.tres")
		"1":
			$SFXPhysPlayer.stream = preload("res://assets/sfx/punch2.tres")
		"2":
			$SFXPhysPlayer.stream = preload("res://assets/sfx/punch3.tres")
			
	$SFXPhysPlayer.play()
	$SFXPhysPlayer.stop()

func _on_AudioStreamPlayer_finished():
	$SFXPhysPlayer.stop()
