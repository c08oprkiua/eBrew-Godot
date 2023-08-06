extends HTTPRequest

@export var data : BrewInfo
@onready var store_fetch = $"."

func _ready():
	SignalBox.connect("Thisitem", downloadicon)
	SignalBox.connect("DLicon", downloadicon)

func _on_repo_load_pressed():
	store_fetch.set_download_file("user://repo.json")
	store_fetch.request("https://wiiu.cdn.fortheusers.org/repo.json")
	print("HBAS Requested")

func _on_request_completed(result, response_code, headers, body):
	SignalBox.emit_signal("Okaytoloadimg")
	print("Request completed")

func downloadicon(arg1):
	var appname = data.Information.packages[arg1].name
	if not FileAccess.file_exists("res://Userfiles/Icons/"+appname+".png"):
		print("Downloading Icon...")
		store_fetch.set_download_file("res://Userfiles/Icons/"+appname+".png")
		store_fetch.request("https://wiiubru.com/appstore/packages/"+appname+"/icon.png")
		print("HBAS Icon Requested")
