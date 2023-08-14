extends Node
@export var data : BrewInfo
@export var NetworkBox : BetterHTTPRequest
var yesloadimg: bool

func _ready():
	data.filesyscheck()
	NetworkBox.InitialConnection()
	#Loading the audio buses is a leftover from (now delayed) custom BGM implimentation
	#AudioServer.set_bus_layout(load("res://TRESfiles/AudioBusLayout.tres"))
	AutoBootBehaviors()
	loadbackgroundimage()

func AutoBootBehaviors():
	data.setini.load(data.inifilepath)
	if data.setini.get_value("AppBehavior", "Autoload"):
		print("Automatic repo loading active")
		if data.setini.get_value("AppBehavior", "AutoDownloadRepo"):
			print("Automatic download detected, waiting for completion")
			NetworkBox.DownloadRepo()
			await SignalBox.DownloadComplete
		print("Proceeding")
		SignalBox.emit_signal("StartList")
	elif data.setini.get_value("AppBehavior", "AutoDownloadRepo"):
		print("Automatic download active")
		NetworkBox.DownloadRepo()
		print("Auto Download enabled")

func loadbackgroundimage():
	var bg
	if data.setini.has_section_key("AppBehavior", "LoadCustomBackgroundImage"):
		if data.setini.get_value("AppBehavior", "LoadCustomBackgroundImage"):
			#This might not work yet
			var CustImgDir = data.setini.get_value("Directories", "CustomBackgroundImageDirectory")
			print(CustImgDir)
			if FileAccess.file_exists(CustImgDir):
				print("Custom PNG Found! Setting background...")
				bg = Image.load_from_file(CustImgDir)
			else:
				print("Couldn't find custom PNG, loading default...")
				bg = Image.load_from_file("res://Assets/eBrewSplash.png")
		else:
			bg = Image.load_from_file("res://Assets/eBrewSplash.png")
	$BrewBackground.set_texture(ImageTexture.create_from_image(bg))
