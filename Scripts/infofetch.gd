extends HTTPRequest

@onready var store_fetch = $"."
const MainURL = "https://wiiu.cdn.fortheusers.org"
var RepoFile := "/repo.json"
var LocalDir = "res://DownloadOutput/"


func _on_button_pressed():
	store_fetch.request(MainURL + RepoFile)

func _on_request_completed(result, response_code, headers, body):
	body.get_string_from_utf8()
	


