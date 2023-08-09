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
@onready var localx

func _ready():
	closebutton()
	SignalBox.connect("InitDir",setinfo, 4)
	SignalBox.connect("Thisitem", focuscheck)
	SignalBox.connect("Processedicon", updooticon)
	SignalBox.connect("Downloadcomplete", IsThisMyIcon)

func setinfo(arg1):
	localx = arg1
	changetext()
	data.changeicon(localx)

func IsThisMyIcon():
	data.changeicon(localx)

func updooticon(arg1):
	if is_same(localx, arg1):
		brewicon.set_texture(data.Icon)
		SignalBox.disconnect("Processedicon", updooticon)
		SignalBox.disconnect("Downloadcomplete", IsThisMyIcon)

func changetext():
	brewname.text = data.Information.packages[localx].title
	brewdetails.text = data.Information.packages[localx].description

@warning_ignore("shadowed_variable_base_class")
func _on_toggled(button_pressed):
	if button_pressed:
		brewinfo.visible= false
		options.visible = true
		download.grab_focus()
	elif not button_pressed:
		closebutton()

func focuscheck(arg1):
	if not is_same(arg1, localx):
		genericitem.set_pressed(false)
		options.visible = false

func closebutton():
		brewinfo.visible = true
		options.visible = false

func whenfocus():
	data.updatevars(localx)
	SignalBox.emit_signal("Thisitem", localx)
	if FileAccess.file_exists(data.UserFiles+"Icons/"+data.appname+".png"):
		data.changeicon(localx)
	else:
		SignalBox.emit_signal("DLicon", localx)

func _on_focus_entered():
	whenfocus()

func _on_mouse_entered():
	whenfocus()
