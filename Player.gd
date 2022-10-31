extends KinematicBody

var velocity = Vector3.ZERO
var speed = 5
var hand_select = false;
var active_hand;
export var gravity = 1
export var player_num = 1

func getBall():
	return $RigidBody

func _physics_process(delta):
	
	# playernumbers for different key inputs and for winner
	var player1 = player_num == 1
	var player2 = player_num == 2
	
	# allows gravity of the rigid body to be variable by the map
	$RigidBody.gravity_scale = gravity
	
	# input handling
	var right = Vector3(0, 0.1, 0)
	
	var forward = Vector3(sin($PhysPlayer.getBodyAngle().y), 0 ,cos($PhysPlayer.getBodyAngle().y))
	$RigidBody.add_central_force(forward*0.001)
	var right1 = Input.is_action_pressed("right_1")
	var right2 = Input.is_action_pressed("right_2")
	
	if right1 and player1 or right2 and player2:
		$PhysPlayer.setBodyAngle($PhysPlayer.getBodyAngle() - right)
	
	var left1 = Input.is_action_pressed("left_1")
	var left2 = Input.is_action_pressed("left_2")
	
	if player1 and left1 or player2 and left2:
		$PhysPlayer.setBodyAngle($PhysPlayer.getBodyAngle() + right)
		
	var up1 = Input.is_action_pressed("up_1")
	var up2 = Input.is_action_pressed("up_2")
	
	if player1 and up1 or player2 and up2:
		forward = Vector3(sin($PhysPlayer.getBodyAngle().y), 0 ,cos($PhysPlayer.getBodyAngle().y))
		$RigidBody.add_central_force(forward*speed)
		if ($PhysPlayer/body.rotation_degrees.x < 20):
			$PhysPlayer/body.rotation_degrees.x += 1
	
	var down1 = Input.is_action_pressed("down_1")
	var down2 = Input.is_action_pressed("down_2")
	
	if player1 and down1 or player2 and down2:
		forward = Vector3(sin($PhysPlayer.getBodyAngle().y), 0 ,cos($PhysPlayer.getBodyAngle().y))
		$RigidBody.add_central_force(forward*-speed)
		if ($PhysPlayer/body.rotation_degrees.x > -20):
			$PhysPlayer/body.rotation_degrees.x -= 1
			
	# Reset the player's lean when not moving forwards or backwards
	if (!Input.is_action_pressed("down_1") && !Input.is_action_pressed("up_1")):
		if ($PhysPlayer/body.rotation_degrees.x < 0):
			$PhysPlayer/body.rotation_degrees.x += 1
		if ($PhysPlayer/body.rotation_degrees.x > 0):
			$PhysPlayer/body.rotation_degrees.x -= 1

	if Input.is_action_just_pressed("punch_1"):
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
