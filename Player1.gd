extends KinematicBody
signal opp_hit

export var speed = 7.0
export var jump_impulse = 15.0
export var bounce_impulse = 16.0
export var gravity = 60.0

var just_jumped = false
var fell = false
var recovering = false
var running = false
var kicking = false

var velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if kicking:
		$AnimationPlayer.playback_speed = 3.0
	else:
		$AnimationPlayer.playback_speed = 1.0
		$Pivot/Kick.monitoring = false
		$Pivot/Kick/MeshInstance.visible = false
	
	if not recovering:
		if Input.is_action_just_pressed("kick"):
			$Timer.start()
			$KickPeak.start()
			kicking = true
			$AnimationPlayer.play("Kick")
		if Input.is_action_pressed("turn_right"):
			direction.x += 1
			$Pivot.look_at(translation - direction, Vector3.UP)
		if Input.is_action_pressed("turn_left"):
			direction.x -= 1
			$Pivot.look_at(translation - direction, Vector3.UP)
		if Input.is_action_pressed("move_back"):
			direction.z += 1
		if Input.is_action_pressed("move_forward"):
			direction.z -= 1
			$Pivot.look_at(translation - direction, Vector3.UP)
		if direction != Vector3.ZERO:
			direction = direction.normalized()
			$Pivot.look_at(translation - direction, Vector3.UP)
	
	if recovering:
		$AnimationPlayer.play("HardFalling")

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	if velocity != Vector3.ZERO and not kicking:
		speed = 6.0
		$AnimationPlayer.play("Run")
	
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
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
	
	if velocity == Vector3.ZERO and not just_jumped and not kicking and not recovering:
		$AnimationPlayer.play("Idle")
	
	velocity.y -= gravity * delta 
	velocity = move_and_slide(velocity, Vector3.UP)

func _on_Timer_timeout():
	kicking = false

func _on_KickPeak_timeout():
	$Pivot/Kick.monitoring = true
	$Pivot/Kick/MeshInstance.visible = true

func _on_Kick_body_entered(body):
	emit_signal("opp_hit")

func _on_Player2_opp_hit():
	$HitTimer.start()
	recovering = true

func _on_HitTimer_timeout():
	recovering = false

