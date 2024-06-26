extends RefCounted
class_name RefHelpers

#This is a class I made for various helper functions that I didn't want sticking 
#around in RAM when they were done

var Information:Dictionary
var reposet: bool = false

func BufferToJSON(downloadedbuffer: PackedByteArray) -> void:
	var raw:String = downloadedbuffer.get_string_from_utf8()
	if JSON.parse_string(raw) == null: 
		OS.alert("There's an issue with the repo.json file, try redownloading it", "repo.json could not be read")
		reposet = false
	else:
		Information = JSON.parse_string(raw)
		reposet = true

func JSONToAppInfo() -> bool:
	if not reposet:
		return false
	var list:int = Information.packages.size()
	for items:int in range(0, list):
		var infodict:Dictionary = BrewInfo.Information.packages[items]
		var newitem:HBASAppInfo = HBASAppInfo.new(infodict)
		BrewInfo.AppInfoArray.append(newitem)
	return true

func UnZipBrew(dirp:String) -> void:
	var zip:ZIPReader = ZIPReader.new()
	zip.open(dirp)
	for items:String in zip.get_files():
		var itemdir:String = items.get_base_dir()
		print(items)
		var extfile:FileAccess = FileAccess.open(BrewInfo.InternalDownloadDir+items.get_file(),FileAccess.WRITE_READ)
		var content:PackedByteArray = zip.read_file(items)
		extfile.store_buffer(content)
		if not DirAccess.dir_exists_absolute(BrewInfo.InternalDownloadDir+itemdir+"/"):
			for folders in items.count("/"):
				print(items.get_slice("/", folders))
				print("Dir made")
				DirAccess.make_dir_absolute(BrewInfo.InternalDownloadDir+items.get_slice("/", folders)+"/")
		DirAccess.rename_absolute(BrewInfo.InternalDownloadDir+items.get_file(), items)
