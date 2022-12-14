extends Spatial

#variables used for map rotation
var ROT_SPEED = 0.0015
var direction = Vector3.FORWARD
var switch = false
var counter = 1
var rotate = false
var exclaimCD = false
export (PackedScene) var exclaim_scene

var start = false #can the players move

#game attributes for UI
var score1 = 0
var score2 = 0
var round_num = 1
var winner
var play_to = 3

#player nodes
onready var player1 = get_node("Player")
onready var player2 = get_node("Player2")
var player1_scene = preload("res://Player.tscn")
var player2_scene = preload("res://Player2.tscn")

onready var currentMap = get_node("Map/Walls")
var map1 = preload("res://Map1.tscn")
var house = preload("res://HouseMap.tscn")
var switchMap = true

#signal used for camera
signal player_pos(p1_pos, p2_pos)

#signal for game over menu
signal game_over

func _process(delta):
	
	#emit_signal("player_pos", player1.translation, player2.translation)
	var rotation = currentMap.rotation_degrees.z as int
	$Camera._move_cam(player1.getPhysPlayer().getBodyPosition(), player2.getPhysPlayer().getBodyPosition())
	
	if score1 == play_to or score2 == play_to:
		if score1 == play_to:
			winner = "one"
			$StageSFX.play()
		else:
			winner = "two"
			$StageSFX.play()
		start = false
		$HUD/Timer.stop()
		$RotationTimer.stop()
		$HUD/Clear_Text.stop()
		$HUD/Message.text = "Player " + winner + " wins!"
		emit_signal("game_over")
	
	#players are able to move
	if start:
		
		player1.start = true
		player2.start = true
		
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
	
#resetting when a player falls off the map
func _on_Deathzone_body_entered(body):
	
	start = false
	#incrementing the score
	if body.get_owner().get_owner().player_num == 2:
		score1 +=1
		$HUD.score1 +=1
	elif body.get_owner().get_owner().player_num == 1:
		score2 +=1
		$HUD.score2 +=1
	
	# resetting player positions
	player1.queue_free()
	player2.queue_free()
	
	var player1_new = player1_scene.instance()
	self.add_child(player1_new)
	player1 = player1_new
	
	var player2_new = player2_scene.instance()
	self.add_child(player2_new)
	player2 = player2_new
	
	#resetting map and UI
	counter = 1
	round_num += 1
	
	currentMap.rotation = Vector3(0, 0, 0)
	$HUD/Message.visible = true
	$HUD/Message.text = "Round " + str(round_num)
	$RotationTimer.stop()
	$HUD.counter = 10
	$HUD/Timer.stop()
	
	$HUD/Start_Buffer.start()

func _disp_ow(hitter):
	
	if !exclaimCD:
		$ExclaimTimer.start()
		var exclamation = exclaim_scene.instance()
		
		if(hitter == 1):
			exclamation.translate(player2.getPhysPlayer().getBodyPosition())
		else:
			exclamation.translate(player1.getPhysPlayer().getBodyPosition())
			
		exclamation.translate(Vector3(0, 1, 0))
		add_child(exclamation)
		exclaimCD = true
	else:
		pass

func _on_ExclaimTimer_timeout():
	exclaimCD = false

func _on_Start_Buffer_timeout():
	start = true
	$RotationTimer.start()

func _on_MapToggle_pressed():
	currentMap.queue_free()
	var newMap
	if switchMap:
		switchMap = not switchMap
		newMap = house.instance()
	else:
		switchMap = not switchMap
		newMap = map1.instance()

	currentMap = newMap
	$Map.add_child(newMap)
	
	
