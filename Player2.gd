extends KinematicBody
signal opp_hit

export var speed = 2.0
export var jump_impulse = 10.0
export var gravity = 60.0
export var player_num = 1

var just_jumped = false
var fell = false
var recovering = false
var running = false
var kicking = false

var velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	#speed up kick animation (was too slow)
	if kicking:
		$AnimationPlayer.playback_speed = 3.0
	else:
		$AnimationPlayer.playback_speed = 1.0
		
	
	#if the player is not recovering from a kick
	if not recovering:
		
		#boolean used for conditional of each movement input
		var player1 = player_num == 1
		var player2 = player_num == 2
		
		#player controls
		
		#kick
		var kick1 =  Input.is_action_just_pressed("kick_1")
		var kick2 = Input.is_action_just_pressed("kick_2")
		if kick1 and player1 or kick2 and player2:
			$Timer.start()
			$KickPeakStart.start()
			$KickPeakEnd.start()
			kicking = true
			$AnimationPlayer.play("Kick")
			
		#move right 
		var right1 = Input.is_action_pressed("right_1")
		var right2 = Input.is_action_pressed("right_2")
		if right1 and player1 or right2 and player2:
			running = true
			direction.x += 1
			
		#move left
		var left1 = Input.is_action_pressed("left_1")
		var left2 = Input.is_action_pressed("left_2")
		if left1 and player1 or left2 and player2:
			direction.x -= 1
			
		#move down 
		var down1 = Input.is_action_pressed("down_1") #s key
		var down2 = Input.is_action_pressed("down_2") #down arrow
		if down1 and player1 or down2 and player2:
			direction.z += 1
			
		#move up
		var up1 = Input.is_action_pressed("up_1") #w key
		var up2 = Input.is_action_pressed("up_2") #up arrow
		if up1 and player1 or up2 and player2:
			direction.z -= 1
		else:
			running = false
		#jumping
		var jump1 = Input.is_action_just_pressed("jump_1") and player1
		var jump2 = Input.is_action_just_pressed("jump_2") and player2
		if is_on_floor() and (jump1 or jump2):
			if kicking:
				kicking = false
			$AnimationPlayer.play("FallingStart")
			$Timer.start()
			velocity.y += jump_impulse
			just_jumped = true
		if not is_on_floor() and just_jumped:
			fell = true
			if not kicking:
				$AnimationPlayer.play("Falling")
		if is_on_floor() and fell:
			just_jumped = false
			fell = false
		if direction != Vector3.ZERO:
			if not kicking:
				$AnimationPlayer.play("Run")
			direction = direction.normalized()
			$Pivot.look_at(translation - direction, Vector3.UP)
		
	#if the player was just kicked
	if recovering:
		$AnimationPlayer.play("HardFalling")
	
	if direction == Vector3.ZERO and not (kicking or just_jumped or running or recovering):
		$AnimationPlayer.play("Idle")
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	velocity.y -= gravity * delta 
	velocity = move_and_slide(velocity, Vector3.UP)

func _on_Timer_timeout():
	kicking = false

#if the current 
func _on_Kick_body_entered(body):
	emit_signal("opp_hit")

func _on_HitTimer_timeout():
	recovering = false

func _on_KickPeakStart_timeout():
	$Pivot/Kick.monitoring = true
	print("kick")
func _on_KickPeakEnd_timeout():
	print("end")
	$Pivot/Kick.monitoring = false

func _hit():
	$HitTimer.start()
	recovering = true
