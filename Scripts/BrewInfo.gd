extends Resource
class_name BrewInfo

@export var title = "Title"
@export var description = "Description"
@export var details = "Details"
@export var Information = {}

func JSONdecoding():
	print("Attempting to load saved repo...")
	if FileAccess.file_exists("res://Userfiles/repo.json"):
		var raw = FileAccess.get_file_as_string("res://Userfiles/repo.json")
		var repo = JSON.parse_string(raw)
		Information = repo
		print("Repo file decoded")
	else:
		print("Repo file not present")
