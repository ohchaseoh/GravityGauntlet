extends Control

export var counter = 10

var game_over = false

var score1 = 0
var score2 = 0

func _process(delta):
	
	$Label.text = str(counter)
	$text1.text = "Player one: " + str(score1)
	$text2.text = "Player two: " + str(score2)
	if counter == 0:
		$Label.text = "GRAVITY OFF"

func _on_Timer_timeout():
	if counter == 0:
		counter = 10
	counter -=1

func _on_Button_pressed():
	if game_over:
		get_tree().reload_current_scene()
	$Message.text = "ROUND 1"
	$Start_Buffer.start()
	$Button.visible = false
	$MapToggle.visible = false
	
func _on_Clear_Text_timeout():
	$Message.visible = false

func _on_Start_Buffer_timeout():
	$Message.text = "FIGHT!"
	$Clear_Text.start()
	$Timer.start()

func _on_Main_game_over():
	$Button.text = "Play Again"
	$Button.visible = true
	game_over = true
