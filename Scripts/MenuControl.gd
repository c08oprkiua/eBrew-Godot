extends TextureButton
#Note: Code needs to be cleaned up at some point
@onready var options:HBoxContainer = $OptionContainer
@onready var brewinfo:VSplitContainer = $InfoContainer
@onready var brewname:Label = $InfoContainer/Title
@onready var brewdetails:RichTextLabel = $InfoContainer/Description
@onready var genericitem:TextureButton = $"."
@onready var delete:TextureButton = $OptionContainer/Delete
@onready var download:TextureButton = $OptionContainer/Download
@onready var settings:TextureButton = $OptionContainer/Settings
@onready var brewicon:TextureRect = $ItemIcon
@onready var localx:int

func _ready() -> void:
	closebutton()
	SignalBox.connect("InitDir",setinfo, 4)
	SignalBox.connect("Thisitem", focuscheck)
	SignalBox.connect("Processedicon", updooticon)
	SignalBox.connect("DownloadComplete", IsThisMyIcon)
	SignalBox.connect("Gohere", GrabFocus)

func setinfo(arg1:int) -> void:
	localx = arg1
	changetext()
	BrewInfo.changeicon(localx)

func changetext() -> void:
	brewname.text = BrewInfo.Information.packages[localx].title
	brewdetails.text = BrewInfo.Information.packages[localx].description

#Icon setting/requesting
func updooticon(arg1:int) -> void:
	if is_same(localx, arg1):
		brewicon.set_texture(BrewInfo.Icon)
		SignalBox.disconnect("Processedicon", updooticon)
		SignalBox.disconnect("DownloadComplete", IsThisMyIcon)

func IsThisMyIcon() -> void:
	BrewInfo.changeicon(localx)

#Button related processes
func _on_toggled(toggled_on:bool) -> void:
	if toggled_on:
		brewinfo.visible= false
		options.visible = true
		download.grab_focus()
	else:
		closebutton()

func _on_download_pressed() -> void:
	BetterDownloading.DownloadBrew(BrewInfo.appname)

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_delete_pressed() -> void:
	DirAccess.remove_absolute(BrewInfo.UserFiles+"Downloads/"+BrewInfo.appname+".zip")

func closebutton() -> void:
		brewinfo.visible = true
		options.visible = false

#Focus related
func focuscheck(arg1:int) -> void:
	if not is_same(arg1, localx):
		genericitem.set_pressed(false)
		options.visible = false

func whenfocus() -> void:
	BrewInfo.appname = BrewInfo.Information.packages[localx].name
	#BrewInfo.updatevars(localx)
	SignalBox.emit_signal("Thisitem", localx)
	if FileAccess.file_exists(BrewInfo.UserFiles+"Icons/"+BrewInfo.appname+".png"):
		BrewInfo.changeicon(localx)
	else:
		BetterDownloading.DownloadIcon(BrewInfo.appname)

func GrabFocus(where:int) -> void:
	if where == localx:
		self.grab_focus()

func _on_focus_entered() -> void:
	whenfocus()

func _on_mouse_entered() -> void:
	whenfocus()
