extends Resource
##This is a wrapper class for an app listing on the Homebrew App Store.
class_name HBASAppInfo

##The directory where all [HBASAppInfo] resources will save to.
const save_directory:String = "user://AppInfo/"


##Template for the URL for downloading the icon.
const icon_template: String = "/packages/{name}/icon.png"
##Template for the URL for downloading the banner.
const banner_template: String = "/packages/{name}/screen.png"
##Template for the URL for downloading the icon.
const screenshot_template: String = "/packages/{name}/screen{num}.png"
##Template for the URL for downloading the app.
const zip_template: String = "/zips/{name}.zip"

##The category (categories?) this app is in.
@export var category:String
##Path on the SD card to the binary.
@export var binary:String
##When the app was last updated.
@export var updated:String
##The API-side name of the app.
@export var name:StringName
##The license the app is distributed under.
@export var license:String
##The publicly viewable name of the app.
@export var title:String
##The URL to the source code of the app.
@export var url:String
##The short description of what the app is.
@export_multiline var description:String
##The app's author (or authors).
@export var author:String
##The entry from the latest change in the changelog of the app.
@export_multiline var changelog:String
##How many screenshots are available for the app.
@export var screens:int
##????????
@export var extracted:int
##Current version of the app.
@export var version:String
##????????
@export var filesize:int
##The long description about the app.
@export_multiline var details:String
##How many times this app has been downloaded.
@export var app_dls:int
##The MD5 checksum of this app.
@export var md5:String
##The icon for the app.
@export var icon:Image = null
##The banner for the app.
@export var banner:Image = null
##Screenshots for the app.
@export var screenshots:Array[Image]

#After a lot of deliberation and working on other things, I decided that the best way to handle
#downloading everything efficiently was to have each HBASAppInfo handle it. Downloading on the main
#thread is notoriously lag prone, so a thread is ran for downloading.
var net_fetch:SimpleHTTP = SimpleHTTP.new()

var fetch_thread:Thread = Thread.new()

##A signal that is emitted when the download of the icon is done.
signal icon_download_done
##A signal that is emitted when the download of the banner is done.
signal banner_download_done
##A signal that is emitted when the download of the screenshots are done.
signal screenshots_download_done
##A signal that is emitted when the download of the app is done.
signal app_download_done

func _init(info:Dictionary = {}) -> void:
	if not info.is_empty():
		InformationFromDictionary(info)

##Loads information from a repo.json app info dictionary.
func InformationFromDictionary(information: Dictionary) -> void:
	for keys in information.keys():
		self.set(keys, information.get(keys))

func get_save_directory() -> String:
	return save_directory + name + ".tres"

##Download the icon for the app.
func downloadIcon() -> void:
	net_fetch.request_resources #= something something load prefab
	
	net_fetch.connect("download_done", applyIcon, CONNECT_ONE_SHOT)
	#fetch_thread.start(net_fetch.download, Thread.PRIORITY_LOW)

func applyIcon() -> void:
	icon.load_png_from_buffer(net_fetch.buffer)
	emit_signal("icon_download_done")

##Download the banner for the app.
func downloadBanner() -> void:
	net_fetch.download()

##Download the screenshot(s) for the app, if there are any.
func downloadScreenshots() -> void:
	net_fetch.download()

##Download the app.
func downloadApp() -> void:
	net_fetch.download()

##Save this HBASAppInfo Resource to the filesystem for caching purposes.
func save() -> void:
	ResourceSaver.save(self, save_directory + name + ".tres")
