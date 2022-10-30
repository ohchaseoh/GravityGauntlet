extends StaticBody

var ROT_SPEED = 0.00006
var direction = Vector3.FORWARD

var scale_x = 1.0
var scale_y = 1.0
var scale_z = 1.0

func _process(delta):
	#transform.basis = Basis()
	match_box()
	self.rotate(Vector3(1, 0, 0), ROT_SPEED)
	self.rotate(Vector3(0, 0, 1), ROT_SPEED)
	
func match_box():
	var transform = get_node("CollisionShape").get_shape()
	var tmp = transform.get_extents()
	transform.set_extents(Vector3(scale_x, scale_y, scale_z))
