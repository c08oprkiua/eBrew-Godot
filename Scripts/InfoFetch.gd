extends HTTPRequest

@export var data : BrewInfo

@onready var store_fetch = $"."
var MainURL = "https://wiiu.cdn.fortheusers.org/repo.json"
var LocalDir = "res://Userfiles/repo.json"

func _on_repo_load_pressed():
	store_fetch.set_download_file(LocalDir)
	store_fetch.request(MainURL)
	print("HBAS Requested")

func _on_request_completed(result, response_code, headers, body):
	emit_signal("Okaytoload")
	print("Request completed")
