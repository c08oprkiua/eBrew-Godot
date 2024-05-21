extends Resource
##A mini resource for making subsequent requests to the same host easier
class_name SimpleDownloadInfo

@export var query_path:String

@export var download_path:String

@export var headers:PackedStringArray

##The information for uniheaders
var clientinfo: Dictionary = {"version": BrewInfo.version, "Client": OS.get_distribution_name()}
##Universal headers sent in all requests, to help HBAS devs know the request origins
var uniheaders:String = "User-Agent: eBrew ver {version} {Client} client"

func _init() -> void:
	headers.append(uniheaders.format(clientinfo))
