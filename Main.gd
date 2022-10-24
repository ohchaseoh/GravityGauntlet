extends Spatial
var ROT_SPEED = 0.0001
var direction = Vector3.FORWARD
func _process(delta):

	$StaticBody.rotate(Vector3(1, 0, 0), ROT_SPEED)
	$StaticBody.rotate(Vector3(0, 0, 1), ROT_SPEED)
