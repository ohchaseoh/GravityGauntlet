extends Spatial
var ROT_SPEED = 0.0015
var direction = Vector3.FORWARD
var switch = false
var counter = 1
var rotate = false
var exclaimCD = false
onready var player1 = get_node("Player")
onready var player2 = get_node("Player2")
export (PackedScene) var exclaim_scene

func _process(delta):
	
	emit_signal("player_pos", player1.translation, player2.translation)
	var rotation = $Walls.rotation_degrees.z as int
	$Camera._move_cam($Player/PhysPlayer.getBodyPosition(), $Player2/PhysPlayer.getBodyPosition())
	
	if rotate:
		player1.gravity = -0.1
		player2.gravity = -0.1
		
	else:
		player1.gravity = 1
		player2.gravity = 1
	if switch:
		$HUD/Label.text = "Gravity OFF"
		$RotationTimer.paused = true
		$HUD/Timer.paused = true
		if rotation < 360:
			_rotateDownLeft()
		if rotation == 90 and counter == 1:
			counter = 2
			switch = false
			$RotationTimer.paused = false
			$HUD/Timer.paused = false
			rotate = false
		if rotation == 179 and counter == 2:
			counter = 3
			switch = false
			rotate = false
			$RotationTimer.paused = false
			$HUD/Timer.paused = false
		if rotation == -90 and counter == 3:
			counter = 4
			switch = false
			rotate = false
			$RotationTimer.paused = false
			$HUD/Timer.paused = false
		if rotation == 0 and counter == 4:
			counter = 1
			switch = false
			rotate = false
			$RotationTimer.paused = false
			$HUD/Timer.paused = false
		

func _rotateDownLeft():
	$Walls.rotate(Vector3(0, 0, 1), ROT_SPEED)
	rotate = true

func _on_RotationTimer_timeout():
	switch = true
	

func _on_Deathzone_body_entered(body):
	pass
	get_tree().reload_current_scene()

func _disp_ow(hitter):
	if !exclaimCD:
		$ExclaimTimer.start()
		var exclamation = exclaim_scene.instance()
		if(hitter == 1):
			exclamation.translate($Player2/PhysPlayer.getBodyPosition())
		else:
			exclamation.translate($Player/PhysPlayer.getBodyPosition())
		exclamation.translate(Vector3(0, 1, 0))
		add_child(exclamation)
		exclaimCD = true
	else:
		pass

func _on_ExclaimTimer_timeout():
	exclaimCD = false
