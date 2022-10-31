extends KinematicBody

var velocity = Vector3.ZERO
var speed = 4
var hand_select = false;
var active_hand;
var gravity = 1
var start = false

export var player_num = 2

func getBall():
	return $RigidBody
	
func getPhysPlayer():
	return $PhysPlayer

func _physics_process(delta):
	
	if start:
		$RigidBody.gravity_scale = gravity
		# Input handling
		var right = Vector3(0, 0.05, 0)
		var forward = Vector3(sin($PhysPlayer.getBodyAngle().y), 0 ,cos($PhysPlayer.getBodyAngle().y))
		$RigidBody.add_central_force(forward*0.001)
		if Input.is_action_pressed("right_2"):
			$PhysPlayer.setBodyAngle($PhysPlayer.getBodyAngle() - right)
			
		if Input.is_action_pressed("left_2"):
			$PhysPlayer.setBodyAngle($PhysPlayer.getBodyAngle() + right)
			
		if Input.is_action_pressed("up_2"):
			forward = Vector3(sin($PhysPlayer.getBodyAngle().y), 0 ,cos($PhysPlayer.getBodyAngle().y))
			$RigidBody.add_central_force(forward*speed)
			if ($PhysPlayer/body.rotation_degrees.x < 20):
				$PhysPlayer/body.rotation_degrees.x += 1
				
		if Input.is_action_pressed("down_2"):
			forward = Vector3(sin($PhysPlayer.getBodyAngle().y), 0 ,cos($PhysPlayer.getBodyAngle().y))
			$RigidBody.add_central_force(forward*-speed)
			if ($PhysPlayer/body.rotation_degrees.x > -20):
				$PhysPlayer/body.rotation_degrees.x -= 1
				
		# Reset the player's lean when not moving forwards or backwards
		if (!Input.is_action_pressed("down_2") && !Input.is_action_pressed("up_2")):
			if ($PhysPlayer/body.rotation_degrees.x < 0):
				$PhysPlayer/body.rotation_degrees.x += 1
			if ($PhysPlayer/body.rotation_degrees.x > 0):
				$PhysPlayer/body.rotation_degrees.x -= 1

		if Input.is_action_just_pressed("punch_2"):
			$PhysPlayer/hand_l.linear_damp = 99999
			$PhysPlayer/hand_r.linear_damp = 99999
			if (hand_select):
				active_hand = $PhysPlayer/hand_l
			else:
				active_hand = $PhysPlayer/hand_r
			
			# Move the hands rapidly in the direction the player is facing
			forward = Vector3(sin($PhysPlayer.getBodyAngle().y), 0 ,cos($PhysPlayer.getBodyAngle().y))
			var temp_offset = Vector3(0, 3, 0)
			var target = $PhysPlayer.getBodyPosition() + (forward*3 + temp_offset)
			active_hand.add_central_force((active_hand.global_transform.origin - target) * -900)
			
			hand_select = !hand_select
		else:
			$PhysPlayer/hand_l.linear_damp = -1
			$PhysPlayer/hand_r.linear_damp = -1
			
	# Set the position of the body
	var offset = Vector3(0,0.3,0)
	$PhysPlayer.setBodyPosition($RigidBody.global_transform.origin + offset)

func _ready():
	$PhysPlayer.connect("hit", self.get_parent(), "_disp_ow")
