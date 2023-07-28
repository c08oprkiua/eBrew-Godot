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
@export var data : BrewInfo
@onready var x

func _ready():
	options.visible = false
	brewinfo.visible = true
	SignalBox.connect("InitDir",changetext, 4)

func changetext(arg1):
	brewname.text = data.Information.packages[arg1].title
	brewdetails.text = data.Information.packages[arg1].description

#Changes if the info or options are on screen based on what state
# the button is when pressed.
func _on_toggled(button_pressed):
	if button_pressed:
		brewinfo.visible= false
		options.visible = true
		download.grab_focus()
	elif not button_pressed:
		brewinfo.visible= true
		options.visible = false

func focuscheck():
	var focusdownload = download.has_focus()
	var focussetting = settings.has_focus() 
	var focusdelete = delete.has_focus()
	if not has_focus() == focusdownload or focusdelete or focussetting:
		genericitem.set_pressed(false)
		options.visible = false

func _on_focus_exited():
	focuscheck()

func _on_download_focus_exited():
	focuscheck()

func _on_settings_focus_exited():
	focuscheck()

func _on_delete_focus_exited():
	focuscheck()
