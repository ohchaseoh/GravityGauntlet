extends KinematicBody

var velocity = Vector3.ZERO
var hand_select = false;
var active_hand;
var speed = 5
var hand_select = false;
var active_hand;
export var gravity = 1
export var player_num = 1

func getBall():
	return $RigidBody

func _physics_process(delta):
	
	# allows gravity of the rigid body to be variable by the map
	$RigidBody.gravity_scale = gravity
	
	# input handling
	var right = Vector3(0, 0.1, 0)
	if Input.is_action_pressed("p1_right"):
		$PhysPlayer.setBodyAngle($PhysPlayer.getBodyAngle() - right)
		
	if Input.is_action_pressed("p1_left"):
		$PhysPlayer.setBodyAngle($PhysPlayer.getBodyAngle() + right)
		
	if Input.is_action_pressed("p1_forward"):
		var forward = Vector3(sin($PhysPlayer.getBodyAngle().y), 0 ,cos($PhysPlayer.getBodyAngle().y))
		$RigidBody.add_central_force(forward*20)
		if ($PhysPlayer/body.rotation_degrees.x < 20):
			$PhysPlayer/body.rotation_degrees.x += 1
			
	if Input.is_action_pressed("p1_back"):
		var forward = Vector3(sin($PhysPlayer.getBodyAngle().y), 0 ,cos($PhysPlayer.getBodyAngle().y))
		$RigidBody.add_central_force(forward*-20)
	
	var forward = Vector3(sin($PhysPlayer.getBodyAngle().y), 0 ,cos($PhysPlayer.getBodyAngle().y))
	$RigidBody.add_central_force(forward*0.001)
	
		if ($PhysPlayer/body.rotation_degrees.x > -20):
			$PhysPlayer/body.rotation_degrees.x -= 1
			
	# Reset the player's lean when not moving forwards or backwards
	if (!Input.is_action_pressed("p1_back") && !Input.is_action_pressed("p1_forward")):
		if ($PhysPlayer/body.rotation_degrees.x < 0):
			$PhysPlayer/body.rotation_degrees.x += 1
		if ($PhysPlayer/body.rotation_degrees.x > 0):
			$PhysPlayer/body.rotation_degrees.x -= 1

	if Input.is_action_just_pressed("p1_punch"):
		$PhysPlayer/hand_l.linear_damp = 99999
		$PhysPlayer/hand_r.linear_damp = 99999
		if (hand_select):
			active_hand = $PhysPlayer/hand_l
		else:
			active_hand = $PhysPlayer/hand_r
		
		# Move the hands rapidly in the direction the player is facing
		var forward = Vector3(sin($PhysPlayer.getBodyAngle().y), 0 ,cos($PhysPlayer.getBodyAngle().y))
		var temp_offset = Vector3(0, 3, 0)
		var target = $PhysPlayer.getBodyPosition() + (forward*3 + temp_offset)
		active_hand.add_central_force((active_hand.global_transform.origin - target) * -1000)
		
		hand_select = !hand_select
	else:
		$PhysPlayer/hand_l.linear_damp = -1
		$PhysPlayer/hand_r.linear_damp = -1
		
	# Set the position of the body
	var offset = Vector3(0,2,0)
	$PhysPlayer.setBodyPosition($RigidBody.global_transform.origin + offset)
