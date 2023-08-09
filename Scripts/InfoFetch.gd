extends HTTPRequest

@export var data : BrewInfo
@onready var store_fetch = $"."
var localx

func _ready():
	SignalBox.connect("DLicon", downloadicon)
	SignalBox.connect("Thisitem", downloadicon)
	SignalBox.connect("StartRepoFetch", StartRepoFetch)

func StartRepoFetch():
	store_fetch.set_download_file(data.UserFiles+"repo.json")
	store_fetch.request("https://wiiu.cdn.fortheusers.org/repo.json")
	print("HBAS Requested")

func _on_request_completed(_result, _response_code, _headers, _body):
	SignalBox.emit_signal("Downloadcomplete")
	print("Request completed")
	#Future internal feature: If this node is currently processing a request, it
	#will make a child of itself, that child takes the request, and then when said
	#child is done, it self deletes

func downloadicon(ent):
	localx = ent
	if not FileAccess.file_exists(data.UserFiles+"Icons/"+data.appname+".png"):
		print("Downloading Icon...")
		store_fetch.set_download_file(data.UserFiles+"/Icons/"+data.appname+".png")
		store_fetch.request("https://wiiubru.com/appstore/packages/"+data.appname+"/icon.png")
		print("HBAS Icon Requested")
