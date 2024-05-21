extends Resource
##This is a class to make working with INI file [i]almost[/i] as seamless as
##working with custom Resources
class_name IniFileWrapper

##The category in the INI for app behavior things.
const behavior_category:String = "AppBehavior"
##The category in the INI for directory paths.
const directory_category:String = "Directories"

##Automatically load HBAS listings. 
##This will not affect the loading of already downloaded apps, once that's implemented.
var Autoload:bool = true:
	set(value):
		Autoload = value
		config.set_value(behavior_category, "Autoload", value)

##Automatically download the repo.
var AutoDownloadRepo:bool = true:
	set(value):
		AutoDownloadRepo = value
		config.set_value(behavior_category, "AutoDownloadRepo", value)

##If true, the custom background music will be loaded if it can be found.
var LoadCustomBackgroundMusic:bool = false:
	set(value):
		LoadCustomBackgroundMusic = value
		config.set_value(behavior_category, "LoadCustomBackgroundMusic", value)

##If true, the custom image will be loaded if it can be found.
var LoadCustomBackgroundImage:bool = false:
	set(value):
		LoadCustomBackgroundImage = value
		config.set_value(behavior_category, "LoadCustomBackgroundImage", value)

##If true, eBrew Store will send a downloaded app to the console over FTP once downloaded.
var AutoFTP:bool = false:
	set(value):
		AutoFTP = value
		config.set_value(behavior_category, "AutoFTP", value)

##Which CDN eBrew Store will fetch from. 
var CDN:String = "wiiu":
	set(value):
		CDN = value
		config.set_value(behavior_category, "CDN", value)

##The download directory for homebrew.
var HomeBrewDirectory:String:
	set(value):
		CustomBackgroundImageDirectory = value.validate_filename()
		config.set_value(directory_category, "HomeBrewDirectory", value)

##The path to the custom app background music.
var CustomMusicDirectory:String:
	set(value):
		CustomBackgroundImageDirectory = value.validate_filename()
		config.set_value(directory_category, "CustomMusicDirectory", value)

##The path to the custom background image.
var CustomBackgroundImageDirectory:String:
	set(value):
		CustomBackgroundImageDirectory = value.validate_filename()
		config.set_value(directory_category, "CustomBackgroundImageDirectory", value)


##The ConfigFIle used by this class
var config:ConfigFile = ConfigFile.new()
##The name of the file that this class saves.
var file_name:String = "ebrew_settings.ini"
##The path to [file_name].
var file_path:String = "user://Userfiles/"

func _init(path:String = "") -> void:
	if not path.is_empty() and FileAccess.file_exists(path):
		config.load(path)

func save() -> void:
	config.save(file_path + file_name)
