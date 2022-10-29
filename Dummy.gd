extends KinematicBody

var velocity = Vector3.ZERO
var hand_select = false;
var active_hand;

func _physics_process(delta):
	
	# Input handling
	# Set the position of the body
	var offset = Vector3(0,2,0)
	$PhysPlayerDummy.setBodyPosition($RigidBody.global_transform.origin + offset)
	
func getBall():
	return $RigidBody
	
	
