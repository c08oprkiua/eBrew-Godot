extends Resource
class_name BrewInfo

#Information is empty, gets filled at runtime with the repo info
var Information = {}
var setini = ConfigFile.new()
var UserFiles = "user://Userfiles/"
var inifilepath = UserFiles+"ebrewsettings.ini"
var DefaultDownloadDir = OS.get_executable_path().get_base_dir() #For exported builds
var RepoDownloadDir = UserFiles+"repo.json"
var Icon
var x
var appname

func JSONdecoding():
	print("Attempting to load saved repo...")
	if FileAccess.file_exists(RepoDownloadDir):
		var raw = FileAccess.get_file_as_string(RepoDownloadDir)
		Information = JSON.parse_string(raw)
		print("Repo file decoded")
		SignalBox.emit_signal("SafeRepo")
	else:
		OS.alert("The repo.json file could not be found","Repo file not present")

func updatevars(arg1):
	x = arg1
	appname = Information.packages[x].name

func changeicon(arg1):
	updatevars(arg1)
	if FileAccess.file_exists(UserFiles+"Icons/"+appname+".png"):
		loadicon()

func loadicon():
	var texture = Image.load_from_file(UserFiles+"Icons/"+appname+".png")
	Icon = ImageTexture.create_from_image(texture)
	SignalBox.emit_signal("Processedicon", x)

func filesyscheck():
	#I'll return to this and make it a range function someday
	if not DirAccess.dir_exists_absolute(UserFiles):
		print("Making "+UserFiles+" folder")
		DirAccess.make_dir_absolute(UserFiles)
	if not DirAccess.dir_exists_absolute(UserFiles+"Icons/"):
		print("Making "+UserFiles+"Icons/ folder")
		DirAccess.make_dir_absolute(UserFiles+"/Icons/")
	if not DirAccess.dir_exists_absolute(UserFiles+"Homebrew/"):
		print("Making "+UserFiles+"Homebrew/ folder")
		DirAccess.make_dir_absolute(UserFiles+"Homebrew/")
	if not DirAccess.dir_exists_absolute(UserFiles+"Downloads/"):
		print("Making "+UserFiles+"Downloads/ folder")
		DirAccess.make_dir_absolute(UserFiles+"Downloads/")
	print("File tree exists at "+UserFiles)	
