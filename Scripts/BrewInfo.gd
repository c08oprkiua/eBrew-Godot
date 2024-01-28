extends Node

#Globally set directories
const UserFiles: String = "user://Userfiles/"
const inifilepath:String = UserFiles+"ebrewsettings.ini"
const InternalDownloadDir:String = UserFiles+"Downloads/"
const RepoDir:String = UserFiles+"repo.json"
const IconDir:String = UserFiles+"Icons/"
const version:float = 0.4

#List info
var Icon: ImageTexture
var x: int
var appname: StringName
var Information: Dictionary
var AppInfoArray: Array[AppInfo]
var setini:ConfigFile = ConfigFile.new()

func JSONdecoding():
	if FileAccess.file_exists(RepoDir):
		var raw:String = FileAccess.get_file_as_string(RepoDir)
		if JSON.parse_string(raw) == null: 
			OS.alert("There's an issue with the repo.json file, try redownloading it", "repo.json could not be read")
		else:
			Information = JSON.parse_string(raw)
			SignalBox.emit_signal("SafeRepo")
	else:
		OS.alert("The repo.json file could not be found", "Repo file not present")

func InitRepoProcess():
	var Reprocessor: RefHelpers = RefHelpers.new()
	var raw:PackedByteArray
	if FileAccess.file_exists(RepoDir):
		raw = FileAccess.get_file_as_bytes(RepoDir)
	

func updatevars(arg1: int):
	x = arg1
	appname = Information.packages[x].name

func changeicon(arg1: int):
	updatevars(arg1)
	if FileAccess.file_exists(IconDir+appname+".png"):
		loadicon()

func loadicon():
	var texture:Image = Image.load_from_file(IconDir+appname+".png")
	if texture == null:
		print("Loading icon failed, initiating redownload")
		BetterDownloading.DownloadIcon(appname)
		return
	Icon = ImageTexture.create_from_image(texture)
	SignalBox.emit_signal("Processedicon", x)

func filesyscheck():
	var checkarray:Array[String] = [UserFiles, IconDir, InternalDownloadDir]
	for directories in checkarray:
		if not DirAccess.dir_exists_absolute(directories):
			DirAccess.make_dir_absolute(directories)
