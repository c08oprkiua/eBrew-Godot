extends Resource
class_name BetterHTTPRequest

var Client = HTTPClient.new()

var clientinfo = {"version": SignalBox.version, "Client": OS.get_distribution_name()}
var uniheaders = "User-Agent: eBrew ver {version} {Client} client"
var iconname: String
var configdir = "user://Userfiles/ebrewsettings.ini"
var downloaddir = "user://Userfiles/Downloads/"
var wiiucdn = "wiiu.cdn.fortheusers.org" 
#This is a variable instead of being hard-coded so that in the future this could maybe support other repos

func InitialConnection():
	print(uniheaders.format(clientinfo))
	IP.clear_cache(wiiucdn)
	Client.connect_to_host(wiiucdn)
	print("Connection set to ", wiiucdn)
	Client.poll()
	while not Client.get_status() == 5:
		Client.poll()
	if Client.get_status() == 5:
		print("Connected!")
		Client.poll()

func Download(url, headers):
	var file = FileAccess.open(downloaddir+url.get_file(),FileAccess.WRITE_READ)
	Client.poll()
	print(Client.get_status())
	if Client.get_status() == 8 or Client.get_status() ==9:
		print("There was an error,", Client.get_status(), " while trying to download")
		IP.clear_cache(wiiucdn)
		InitialConnection()
	else:
		var data = PackedByteArray()
		var allheaders = [uniheaders.format(clientinfo), headers]
		print(allheaders)
		print("Connected! Accessing ", wiiucdn+url)
		Client.request(HTTPClient.METHOD_GET, url, [uniheaders, headers])
		while Client.get_status() == 6:
			Client.poll()
		while Client.get_status() == 7:
			Client.poll()
			var buffer = Client.read_response_body_chunk()
			file.store_buffer(buffer)
			SignalBox.emit_signal("DownloadPercent", file.get_length())
		print("Download complete from BetterDownload, saving file...")
		data.clear()
		FileCleanUp()

func FileCleanUp():
	if FileAccess.file_exists(downloaddir+"repo.json"):
		DirAccess.rename_absolute(downloaddir+"repo.json", "user://Userfiles/repo.json")
	if FileAccess.file_exists(downloaddir+"icon.png"):
		DirAccess.rename_absolute(downloaddir+"icon.png", downloaddir+iconname+".png")
		DirAccess.rename_absolute(downloaddir+iconname+".png", "user://Userfiles/Icons/"+iconname+".png")
	SignalBox.emit_signal("DownloadComplete")
	if FileAccess.file_exists(downloaddir+iconname+".zip"):
		var config = ConfigFile.new()
		config.load(configdir)
		if config.has_section_key("Directories", "HomeBrewDirectory"):
			var HBD = config.get_value("Directories", "HomeBrewDirectory")
			if DirAccess.dir_exists_absolute(HBD):
				print("Valid homebrew directory detected!")
				UnZipBrew()
			else:
				print("Homebrew directory invalid")
		else:
			print("Homebrew directory key not found")

func UnZipBrew():
	var zip = ZIPReader.new()
	zip.open(downloaddir+"Downloads/"+iconname+".zip")
	print(zip.get_files())

func DownloadRepo():
	Download("/repo.json", "Accept: application/json")
	SignalBox.emit_signal("DownloadStarted", false)

func DownloadIcon(appname):
	iconname = appname
	Download("/packages/"+appname+"/icon.png","Accept: image/png")
	SignalBox.emit_signal("DownloadStarted", false)

func DownloadBrew(appname):
	iconname = appname
	Download("/zips/"+appname+".zip", "Accept: application/zip")
	SignalBox.emit_signal("DownloadStarted", true)
