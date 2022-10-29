extends KinematicBody

var velocity = Vector3.ZERO
var hand_select = false;
var active_hand;

func getBall():
	return $RigidBody

func _physics_process(delta):
	
	# Input handling
	var right = Vector3(0, 0.05, 0)
	if Input.is_action_pressed("p2_right"):
		$PhysPlayer.setBodyAngle($PhysPlayer.getBodyAngle() - right)
		
	if Input.is_action_pressed("p2_left"):
		$PhysPlayer.setBodyAngle($PhysPlayer.getBodyAngle() + right)
		
	if Input.is_action_pressed("p2_forward"):
		var forward = Vector3(sin($PhysPlayer.getBodyAngle().y), 0 ,cos($PhysPlayer.getBodyAngle().y))
		$RigidBody.add_central_force(forward*-20)
		if ($PhysPlayer/body.rotation_degrees.x < 20):
			$PhysPlayer/body.rotation_degrees.x += 1
			
	if Input.is_action_pressed("p2_back"):
		var forward = Vector3(sin($PhysPlayer.getBodyAngle().y), 0 ,cos($PhysPlayer.getBodyAngle().y))
		$RigidBody.add_central_force(forward*20)
		if ($PhysPlayer/body.rotation_degrees.x > -20):
			$PhysPlayer/body.rotation_degrees.x -= 1
			
	# Reset the player's lean when not moving forwards or backwards
	if (!Input.is_action_pressed("p2_back") && !Input.is_action_pressed("p2_forward")):
		if ($PhysPlayer/body.rotation_degrees.x < 0):
			$PhysPlayer/body.rotation_degrees.x += 1
		if ($PhysPlayer/body.rotation_degrees.x > 0):
			$PhysPlayer/body.rotation_degrees.x -= 1

	if Input.is_action_just_pressed("p2_punch"):
		$PhysPlayer/hand_l.linear_damp = 99999
		$PhysPlayer/hand_r.linear_damp = 99999
		if (hand_select):
			active_hand = $PhysPlayer/hand_l
		else:
			active_hand = $PhysPlayer/hand_r
		
		# Move the hands rapidly in the direction the player is facing
		var forward = -Vector3(sin($PhysPlayer.getBodyAngle().y), 0 ,cos($PhysPlayer.getBodyAngle().y))
		var temp_offset = Vector3(0, 3, 0)
		var target = $PhysPlayer.getBodyPosition() + (forward*3 + temp_offset)
		active_hand.add_central_force((active_hand.global_transform.origin - target) * -3500)
		
		hand_select = !hand_select
	else:
		$PhysPlayer/hand_l.linear_damp = -1
		$PhysPlayer/hand_r.linear_damp = -1
		
	# Set the position of the body
	var offset = Vector3(0,2,0)
	$PhysPlayer.setBodyPosition($RigidBody.global_transform.origin + offset)
	
	
