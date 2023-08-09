extends Node
@export var data : BrewInfo
var yesloadimg: bool

func _ready():
	data.filesyscheck()
	#Loading the audio buses is a leftover from (now delayed) custom BGM implimentation
	#AudioServer.set_bus_layout(load("res://TRESfiles/AudioBusLayout.tres"))
	#loadbackgroundimage()
	AutoBootBehaviors()

func AutoBootBehaviors():
	data.setini.load(data.inifilepath)
	if data.setini.get_value("AppBehavior", "AutoDownloadRepo"):
		print("Automatic download active")
		SignalBox.emit_signal("StartRepoFetch")
		print("Auto Download enabled")
	if data.setini.get_value("AppBehavior", "Autoload"):
		print("Automatic repo loading active")
		if data.setini.get_value("AppBehavior", "AutoDownloadRepo"):
			print("Automatic download detected, waiting for completion")
			await SignalBox.Downloadcomplete
		SignalBox.emit_signal("StartList")

func loadbackgroundimage():
	var bg
	if FileAccess.file_exists(data.UserDirectory+"/background.png"):
		bg = Image.load_from_file(data.UserDirectory+"/background.png")
		#later on this will directly load an image from a directory in the cfg file
	else:
		bg = Image.load_from_file("res://Assets/eBrewSplash.png")
	$BrewBackground.set_texture(ImageTexture.create_from_image(bg))
