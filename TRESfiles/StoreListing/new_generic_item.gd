extends PanelContainer


@onready var brewname: Label = $'HBoxContainer/MarginContainer/HBoxContainer/InfoContainer/Title'
@onready var brewdetails:RichTextLabel = $"HBoxContainer/MarginContainer/HBoxContainer/InfoContainer/Description"
@onready var delete:Button = $"HBoxContainer/OptionBase/OptionContainer/Delete"
@onready var download:Button = $"HBoxContainer/OptionBase/OptionContainer/Download"
@onready var settings:Button = $"HBoxContainer/OptionBase/OptionContainer/Settings"
@onready var brewicon:TextureRect = $"HBoxContainer/MarginContainer/HBoxContainer/ItemIcon"

var localname: StringName
var localx: int
var icontemplate: String = "/packages/{name}/icon.png"
var ziptemplate: String = "/zips/{name}.zip"
@export var myinfo:AppInfo

func _ready():
	SignalBox.connect("InitDir2",setinfo, 4)

func setinfo(arg1:AppInfo):
	myinfo = arg1
	localname = myinfo.name
	changetext()
	BrewInfo.changeicon(localx)

func changetext():
	brewname.text = myinfo.title
	brewdetails.text = myinfo.description

func _on_store_listing_toggled(button_pressed):
	print("selected: ", button_pressed)
	if button_pressed:
		$"AnimationPlayer".play("Listinganimlib/options_selected")
	else:
		$"AnimationPlayer".play("Listinganimlib/options_unselected")

func _on_download_pressed():
	BetterDownloading.DownloadBrew(BrewInfo.appname)

func _on_settings_pressed():
	pass # Replace with function body.

func _on_delete_pressed():
	$"AnimationPlayer".play("Listinganimlib/deletebrewanim")
	DirAccess.remove_absolute(BrewInfo.UserFiles+"Downloads/"+myinfo.name+".zip")
