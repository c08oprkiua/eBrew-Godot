extends PanelContainer

class_name GenericItem

static var amount:int = 0

@onready var brewname:Label = $"HBoxContainer/VisibilitySwitcher/MarginContainer/InfoContainer/Title"
@onready var brewdetails:RichTextLabel = $"HBoxContainer/VisibilitySwitcher/MarginContainer/InfoContainer/Description"
@onready var delete:Button = $"HBoxContainer/VisibilitySwitcher/OptionBase/OptionContainer/Delete"
@onready var download:Button = $"HBoxContainer/VisibilitySwitcher/OptionBase/OptionContainer/Download"
@onready var settings:Button = $"HBoxContainer/VisibilitySwitcher/OptionBase/OptionContainer/Settings"
@onready var brewicon:TextureRect = $"HBoxContainer/MarginContainer/ItemIcon"
@onready var visibility_switcher:TabContainer = $"HBoxContainer/VisibilitySwitcher"

@export var myinfo:HBASAppInfo = HBASAppInfo.new():
	set(value):
		myinfo = value
		change_text()
		change_icon()
		#BrewInfo.changeicon(localx)
		myinfo.save()

var load_thread:Thread = Thread.new()

signal threaded_loading_done


func _init() -> void:
	amount += 1

func setinfo(item:HBASAppInfo) -> void:
	myinfo = item
	if ResourceLoader.exists(item.get_save_directory(), "HBASAppInfo"):
		connect("threaded_loading_done", load_thread.wait_to_finish)
		ResourceLoader.load_threaded_request(myinfo.get_save_directory(), "HBASAppInfo", true)

func check_loading_progress() -> void:
	var status:ResourceLoader.ThreadLoadStatus
	while status != ResourceLoader.THREAD_LOAD_LOADED:
		status = ResourceLoader.load_threaded_get_status(myinfo.get_save_directory())
		if status == ResourceLoader.THREAD_LOAD_FAILED:
			print("Load failed")
			break
		if status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			print("Invalid resource")
			break
	print("Resource loaded: ", myinfo.name)
	myinfo = ResourceLoader.load_threaded_get(myinfo.get_save_directory())
	emit_signal.call_deferred("threaded_loading_done")

func change_text() -> void:
	brewname.text = myinfo.title
	brewdetails.text = myinfo.description

func change_icon() -> void:
	if myinfo.icon != null:
		brewicon.texture = ImageTexture.create_from_image(myinfo.icon)
	else:
		#What would *actually* go here:
		myinfo.connect("icon_download_done", change_icon, CONNECT_ONE_SHOT)
		myinfo.downloadIcon()
		#patchwork fix
		var img_path:String = "user://Userfiles/Icons/" + myinfo.name + ".png"
		if FileAccess.file_exists(img_path):
			myinfo.icon = Image.load_from_file(img_path)
			brewicon.texture = ImageTexture.create_from_image(myinfo.icon)

func _on_store_listing_toggled(button_pressed:bool) -> void:
	if button_pressed:
		visibility_switcher.current_tab = 1
		#$"AnimationPlayer".play("Listinganimlib/options_selected")
	else:
		visibility_switcher.current_tab = 0
		#$"AnimationPlayer".play("Listinganimlib/options_unselected")

func _on_download_pressed() -> void:
#	BetterDownloading.DownloadBrew(BrewInfo.appname)
	myinfo.downloadApp()

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_delete_pressed() -> void:
	$"AnimationPlayer".play("Listinganimlib/deletebrewanim")
	DirAccess.remove_absolute(BrewInfo.UserFiles+"Downloads/"+myinfo.name+".zip")


func _on_store_listing_focus_exited() -> void:
	$"StoreListing".button_pressed = false
