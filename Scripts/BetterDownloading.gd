extends Node

var Client: HTTPClient = HTTPClient.new()

var clientinfo: Dictionary = {"version": BrewInfo.version, "Client": OS.get_distribution_name()}
var uniheaders:String = "User-Agent: eBrew ver {version} {Client} client"
var responseheaders: Dictionary
var downloadtypes: Dictionary
var iconname: String : set = updatedllist
var file: FileAccess
var preservename: String


var responsebuffer: PackedByteArray
var DLthread:Thread = Thread.new()
var mutex:Mutex = Mutex.new()
var queue = {}
var requestnumber: int = 0
var ConnectOk: bool
var ConnectWarn: bool = true


var currentcdn:String
#This dictionary is usable to access the Switch CDN (secret feature :P)
const cdns:Dictionary = {
	"wiiu": "wiiu.cdn.fortheusers.org",
	"switch": "switch.cdn.fortheusers.org"
}

const repo_download:Dictionary = {
	"path": "/repo.json",
	"headers": "Accept: image/png"
}

const icon_download:Dictionary = {
	"path": "/packages/{value}/icon.png",
	"headers": "Accept: image/png",
}

const package_download:Dictionary = {
	"path": "/zips/{value}.zip",
	"headers": "Accept: application/zip",
}

class QueueItem:
	extends Resource
	var headers:String
	var appname:String
	var url:String
	
	func update_vars(info:Dictionary, appname:String = "") -> void:
		headers = info.get("headers")
		if appname != "":
			url = info.get("path")
		else:
			url = info.get("path")

func updatedllist(value: String) -> void:
	mutex.lock()
	iconname = value
	downloadtypes = {
	1: ["/repo.json", "Accept: application/json"],
	2: ["/packages/"+value+"/icon.png","Accept: image/png"],
	3: ["/zips/"+value+".zip", "Accept: application/zip"],
	}
	mutex.unlock()

func InitialConnection() -> void:
	var conf:ConfigFile = ConfigFile.new()
	conf.load(BrewInfo.inifilepath)
	currentcdn = conf.get_value("AppBehavior", "CDN", "wiiu")
	Client.connect_to_host(cdns.get(currentcdn))
	Client.poll()
	while Client.get_status() != Client.STATUS_CONNECTED:
		Client.poll()
		if Client.get_status() == 0 or Client.get_status() == 2 or Client.get_status() == 4:
			print(Client.get_status())
			if ConnectWarn:
				OS.alert("Could not connect to the appstore server. No new images or homebrew will be loaded.", "No Network Connection")
			ConnectOk = false
			break
	if Client.get_status() == Client.STATUS_CONNECTED:
		ConnectOk = true
		print("Connected")

func Download() -> void:
	for todo in queue:
		var trsbf = queue.get(todo)
		mutex.lock()
		var url = downloadtypes[trsbf][0]
		var headers = downloadtypes[trsbf][1]
		preservename = iconname
		mutex.unlock()
		Client.poll()
		if Client.get_status() == 8:
			IP.clear_cache(currentcdn)
			InitialConnection()
			print("Doof")
		else:
			Client.poll()
			file = FileAccess.open(BrewInfo.InternalDownloadDir+url.get_file(),FileAccess.WRITE_READ)
			Client.request(HTTPClient.METHOD_GET, url, [uniheaders.format(clientinfo), headers])
			while Client.get_status() == 6:
				Client.poll()
				if Client.get_status() == 7:
					responseheaders = Client.get_response_headers_as_dictionary()
			while Client.get_status() == 7:
				Client.poll()
				var buffer:PackedByteArray = Client.read_response_body_chunk()
				responsebuffer.append_array(buffer)
				file.store_buffer(buffer)
				SignalBox.emit_signal.call_deferred("DownloadPercent", file.get_length())
			SignalBox.emit_signal.call_deferred("DownloadComplete")
			FileCleanUp()
	queue.clear()

func FileCleanUp() -> void:
	if FileAccess.file_exists(BrewInfo.InternalDownloadDir+"repo.json"):
		DirAccess.rename_absolute(BrewInfo.InternalDownloadDir+"repo.json", BrewInfo.RepoDir)
	if FileAccess.file_exists(BrewInfo.InternalDownloadDir+"icon.png"):
		mutex.lock()
		DirAccess.rename_absolute(BrewInfo.InternalDownloadDir+"icon.png", BrewInfo.InternalDownloadDir+preservename+".png")
		DirAccess.rename_absolute(BrewInfo.InternalDownloadDir+preservename+".png", BrewInfo.IconDir+preservename+".png")
		mutex.unlock()
	if FileAccess.file_exists(BrewInfo.InternalDownloadDir+iconname+".zip"):
		BrewInfo.setini.load(BrewInfo.inifilepath)
		if BrewInfo.setini.has_section_key("Directories", "HomeBrewDirectory"):
			var HBD = BrewInfo.setini.get_value("Directories", "HomeBrewDirectory")
			if DirAccess.dir_exists_absolute(HBD):
				UnZipBrew(HBD)
		else:
			print("Homebrew directory key not found")
	SignalBox.emit_signal.call_deferred("DownloadComplete")

func UnZipBrew(_directory) -> void:
	var zip = ZIPReader.new()
	zip.open(BrewInfo.InternalDownloadDir+iconname+".zip")
	for items in zip.get_files():
		var itemdir = items.get_base_dir()
		print(items)
		var extfile = FileAccess.open(BrewInfo.InternalDownloadDir+items.get_file(),FileAccess.WRITE_READ)
		var content = zip.read_file(items)
		extfile.store_buffer(content)
		if not DirAccess.dir_exists_absolute(BrewInfo.InternalDownloadDir+itemdir+"/"):
			for folders in items.count("/"):
				print(items.get_slice("/", folders))
				print("Dir made")
				DirAccess.make_dir_absolute(BrewInfo.InternalDownloadDir+items.get_slice("/", folders)+"/")
		DirAccess.rename_absolute(BrewInfo.InternalDownloadDir+items.get_file(), items)

func DownloadRepo() -> void:
	ConnectWarn = true
	queue[requestnumber] = 1
	requestnumber = requestnumber + 1
	if not DLthread.is_started():
		DLthread.start(Download, Thread.PRIORITY_LOW)
	if not DLthread.is_alive():
		DLthread.wait_to_finish()
	SignalBox.emit_signal("DownloadStarted", false)

func DownloadIcon(appname) -> void:
	mutex.lock()
	iconname = appname
	mutex.unlock()
	ConnectWarn = false
	queue[requestnumber] = 2
	requestnumber = requestnumber + 1
	if not DLthread.is_started():
		DLthread.start(Download, Thread.PRIORITY_LOW)
	if not DLthread.is_alive():
		DLthread.wait_to_finish()
	SignalBox.emit_signal("DownloadStarted", false)

func DownloadBrew(appname) -> void:
	iconname = appname
	ConnectWarn = true
	queue[requestnumber] = 3
	requestnumber = requestnumber + 1
	if not DLthread.is_started():
		DLthread.start(Download, Thread.PRIORITY_LOW)
	if not DLthread.is_alive():
		DLthread.wait_to_finish()
	SignalBox.emit_signal("DownloadStarted", true)
