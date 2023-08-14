extends TextureButton
#Note: Code needs to be cleaned up at some point
@onready var options = $OptionContainer
@onready var brewinfo = $InfoContainer
@onready var brewname = $InfoContainer/Title
@onready var brewdetails = $InfoContainer/Description
@onready var genericitem = $"."
@onready var delete = $OptionContainer/Delete
@onready var download = $OptionContainer/Download
@onready var settings = $OptionContainer/Settings
@onready var brewicon = $ItemIcon
@export var data: BrewInfo
@export var NetworkBox: BetterHTTPRequest
@onready var localx

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
	data.changeicon(localx)

func changetext():
	brewname.text = data.Information.packages[localx].title
	brewdetails.text = data.Information.packages[localx].description

#Icon setting/requesting
func updooticon(arg1):
	if is_same(localx, arg1):
		brewicon.set_texture(data.Icon)
		SignalBox.disconnect("Processedicon", updooticon)
		SignalBox.disconnect("DownloadComplete", IsThisMyIcon)

func IsThisMyIcon():
	data.changeicon(localx)

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
	NetworkBox.DownloadBrew(data.appname)

func _on_settings_pressed():
	pass # Replace with function body.

func _on_delete_pressed():
	DirAccess.remove_absolute(data.UserFiles+"Downloads/"+data.appname+".zip")

func closebutton():
		brewinfo.visible = true
		options.visible = false

#Focus related
func focuscheck(arg1):
	if not is_same(arg1, localx):
		genericitem.set_pressed(false)
		options.visible = false

func whenfocus():
	data.updatevars(localx)
	SignalBox.emit_signal("Thisitem", localx)
	if FileAccess.file_exists(data.UserFiles+"Icons/"+data.appname+".png"):
		data.changeicon(localx)
	else:
		NetworkBox.DownloadIcon(data.appname)

func GrabFocus(where):
	if where == localx:
		self.grab_focus()

func _on_focus_entered():
	whenfocus()

func _on_mouse_entered():
	whenfocus()


