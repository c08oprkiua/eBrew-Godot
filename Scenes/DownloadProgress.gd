extends TextureProgressBar

@export var data: BrewInfo
@export var Client: BetterHTTPRequest
@onready var DLProgress = $"."
var total = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBox.connect("DownloadStarted", DownloadStatus)
	SignalBox.connect("DownloadComplete", Reset)

func DownloadStatus(appdownload):
	if appdownload:
		total = data.Information.packages[data.x].filesize
		DLProgress.set_max(total)
		print("Total expected bytes:") 
		print(total)
		SignalBox.connect("DownloadPercent", BarUpdate)
	else:
		total = 1000
		DLProgress.set_max(100)
		DLProgress.set_value(100)

func Reset():
	DLProgress.set_value(0)

func BarUpdate(downloaded):
	while downloaded < total:
		DLProgress.set_value(downloaded)
