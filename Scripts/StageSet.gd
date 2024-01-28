extends Node

func _ready():
	BrewInfo.filesyscheck()
	BetterDownloading.InitialConnection()
	BrewInfo.setini.load(BrewInfo.inifilepath)
	#Loading the audio buses is a leftover from (now delayed) custom BGM implimentation
	#AudioServer.set_bus_layout(load("res://TRESfiles/AudioBusLayout.tres"))
	loadbackgroundimage()
	AutoBootBehaviors()

func AutoBootBehaviors():
	if BrewInfo.setini.get_value("AppBehavior", "Autoload"):
		if BrewInfo.setini.get_value("AppBehavior", "AutoDownloadRepo"):
			await BetterDownloading.DownloadRepo()
			BrewInfo.JSONdecoding()
		else:
			BrewInfo.JSONdecoding()
	elif BrewInfo.setini.get_value("AppBehavior", "AutoDownloadRepo"):
		BetterDownloading.DownloadRepo()

func loadbackgroundimage():
	var bg
	if BrewInfo.setini.has_section_key("AppBehavior", "LoadCustomBackgroundImage"):
		if BrewInfo.setini.get_value("AppBehavior", "LoadCustomBackgroundImage"):
			var CustImgDir = BrewInfo.setini.get_value("Directories", "CustomBackgroundImageDirectory")
			if FileAccess.file_exists(CustImgDir):
				bg = Image.load_from_file(CustImgDir)
				$BrewBackground.set_texture(ImageTexture.create_from_image(bg))
