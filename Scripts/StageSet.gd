extends Node

func _ready():
	#Loading the audio buses is a leftover from (now delayed) custom BGM implimentation
	AudioServer.set_bus_layout(load("res://TRESfiles/AudioBusLayout.tres"))
	loadbackgroundimage()

func loadbackgroundimage():
	var bgpath
	if FileAccess.file_exists("res://Userfiles/background.png"):
		bgpath = "res://Userfiles/background.png"
	else:
		bgpath = "res://Assets/eBrewSplash.png"
	var bg = Image.load_from_file(bgpath)
	var userbg = ImageTexture.create_from_image(bg)
	$BrewBackground.set_texture(userbg)
