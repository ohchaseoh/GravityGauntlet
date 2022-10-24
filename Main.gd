extends Spatial
var ROT_SPEED = 0.0001
var direction = Vector3.FORWARD

signal player_pos(p1_pos, p2_pos)

func _process(delta):
	
	emit_signal("player_pos", $Player.translation, $Player2.translation)
	$StaticBody.rotate(Vector3(1, 0, 0), ROT_SPEED)
	$StaticBody.rotate(Vector3(0, 0, 1), ROT_SPEED)
