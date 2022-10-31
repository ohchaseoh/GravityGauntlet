extends Spatial


# Declare member variables here. Examples:
var fade = false
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var exclamations = ["ow", "ouch", "yeowch", "stop", "owie", "yamete", "help", "oof"]
	var randExclaim = exclamations[randi()% exclamations.size()]
	$Sprite3D/Viewport/OwLabel.text = randExclaim
	$OwTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fade:
		$Sprite3D/Viewport/OwLabel.modulate.a -= 0.005
		
	if $Sprite3D/Viewport/OwLabel.modulate.a == 0:
		queue_free()

func _on_OwTimer_timeout():
	fade = true
