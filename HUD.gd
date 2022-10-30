extends Control
export var counter = 10

func _process(delta):
	$Label.text = str(counter)
	if counter == 0:
		$Label.text = "GRAVITY OFF"

func _on_Timer_timeout():
	if counter == 0:
		counter = 10
	counter -=1
