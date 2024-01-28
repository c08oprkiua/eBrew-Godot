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
@onready var localx: int

func _ready():
	closebutton()
	SignalBox.connect("InitDir",setinfo, 4)
	SignalBox.connect("Thisitem", focuscheck)
	SignalBox.connect("Processedicon", updooticon)
	SignalBox.connect("DownloadComplete", IsThisMyIcon)
	SignalBox.connect("Gohere", GrabFocus)

func setinfo(arg1):
	localx = arg1
	changetext()
	BrewInfo.changeicon(localx)

func changetext():
	brewname.text = BrewInfo.Information.packages[localx].title
	brewdetails.text = BrewInfo.Information.packages[localx].description

#Icon setting/requesting
func updooticon(arg1):
	if is_same(localx, arg1):
		brewicon.set_texture(BrewInfo.Icon)
		SignalBox.disconnect("Processedicon", updooticon)
		SignalBox.disconnect("DownloadComplete", IsThisMyIcon)

func IsThisMyIcon():
	BrewInfo.changeicon(localx)

#Button related processes
@warning_ignore("shadowed_variable_base_class")
func _on_toggled(button_pressed):
	if button_pressed:
		brewinfo.visible= false
		options.visible = true
		download.grab_focus()
	elif not button_pressed:
		closebutton()

func _on_download_pressed():
	BetterDownloading.DownloadBrew(BrewInfo.appname)

func _on_settings_pressed():
	pass # Replace with function body.

func _on_delete_pressed():
	DirAccess.remove_absolute(BrewInfo.UserFiles+"Downloads/"+BrewInfo.appname+".zip")

func closebutton():
		brewinfo.visible = true
		options.visible = false

#Focus related
func focuscheck(arg1):
	if not is_same(arg1, localx):
		genericitem.set_pressed(false)
		options.visible = false

func whenfocus():
	BrewInfo.appname = BrewInfo.Information.packages[localx].name
	#BrewInfo.updatevars(localx)
	SignalBox.emit_signal("Thisitem", localx)
	if FileAccess.file_exists(BrewInfo.UserFiles+"Icons/"+BrewInfo.appname+".png"):
		BrewInfo.changeicon(localx)
	else:
		BetterDownloading.DownloadIcon(BrewInfo.appname)

func GrabFocus(where):
	if where == localx:
		self.grab_focus()

func _on_focus_entered():
	whenfocus()

func _on_mouse_entered():
	whenfocus()
