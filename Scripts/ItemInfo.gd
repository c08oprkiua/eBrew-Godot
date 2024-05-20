extends Resource
class_name AppInfo

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

@export var extracted:int
##Current version of the app.
@export var version:String

@export var filesize:int
##The long description about the app.
@export_multiline var details:String
##How many times this app has been downloaded.
@export var app_dls:int
##The MD5 checksum of this app.
@export var md5:String
##The icon for the app.
@export var icon:Image
##The banner for the app.
@export var banner:Image
##Screenshots for the app.
@export var screenshots:Array[Image]

#After a lot of deliberation and working on other things, I decided that the best way to handle
#downloading everything efficiently was to have each AppInfo handle it. Downloading on the main
#thread is notoriously lag prone, so all download types get their own threads.

##The thread that works on downloading the icon.
var icon_download_thread:Thread = null
##The thread that works on downloading the banner.
var banner_download_thread:Thread = null
##The thread that works on downloading the screenshots.
var screenshots_download_thread:Thread = null
##The thread that works on downloading the app.
var app_download_thread:Thread = null

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

##Download the icon for the app.
func downloadIcon() -> void:
	var client:HTTPClient = HTTPClient.new()

##Download the banner for the app.
func downloadBanner() -> void:
	var client:HTTPClient = HTTPClient.new()

##Download the screenshot(s) for the app, if there are any.
func downloadScreenshots() -> void:
	var client:HTTPClient = HTTPClient.new()

##Download the app.
func downloadApp() -> void:
	pass

##Save this AppInfo Resource to the filesystem for caching purposes.
func save() -> void:
	pass
