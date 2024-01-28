extends Resource
class_name AppInfo

@export var category: String
@export var binary: String
@export var updated: String
@export var name: StringName
@export var license: String
@export var title: String
@export var url: String
@export_multiline var description: String
@export var author: String
@export var changelog: String
@export var screens: int
@export var extracted: int
@export var version: String
@export var filesize: int
@export_multiline var details: String
@export var app_dls: int
@export var md5: String

@export_file(".png") var icon: String
var iconb64: String

func InformationFromDictionary(information: Dictionary):
	for keys in information.keys():
		self.set(keys, information.get(keys))

func SaveIconToB64(imagebytes:PackedByteArray):
	iconb64 = Marshalls.raw_to_base64(imagebytes)

func ConvSavedIcon():
	var img:PackedByteArray = Marshalls.base64_to_raw(iconb64)
	var img2: Image = Image.new()
	img2.load_png_from_buffer(img)
	return img2
