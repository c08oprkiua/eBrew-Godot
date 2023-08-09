extends Resource
class_name BrewInfo

#Information is empty, gets filled at runtime with the repo info
@export var Information = {}
@export var UserDirectory: String
@export var setautoload: bool
var setini = ConfigFile.new()
@export var UserFiles = "res://Userfiles/"
var inifilepath = UserFiles+"ebrewsettings.ini"
var Icon
#Don't access these outside of this script
var x
var appname

func JSONdecoding():
	print("Attempting to load saved repo...")
	if FileAccess.file_exists(UserFiles+"repo.json"):
		var raw = FileAccess.get_file_as_string(UserFiles+"repo.json")
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
	if not DirAccess.dir_exists_absolute(UserFiles):
		print("Making "+UserFiles+" folder")
		DirAccess.make_dir_absolute(UserFiles)
	if not DirAccess.dir_exists_absolute(UserFiles+"Icons/"):
		print("Making icon folder")
		print("Making "+UserFiles+"Icons/ folder")
		
		DirAccess.make_dir_absolute(UserFiles+"/Icons/")
	print("File tree exists at "+UserFiles)
