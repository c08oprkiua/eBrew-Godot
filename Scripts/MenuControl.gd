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
@export var data : BrewInfo
@onready var x

signal FocusCheck

func _ready():
	closebutton()
	SignalBox.connect("InitDir",changetext, 4)

func changetext(arg1):
	brewname.text = data.Information.packages[arg1].title
	brewdetails.text = data.Information.packages[arg1].description
	x = arg1
	changeicon(x)

func changeicon(x):
	var appname = data.Information.packages[x].name
	if FileAccess.file_exists("res://Userfiles/Icons/"+appname+".png"):
		var texture = Image.load_from_file("res://Userfiles/Icons/"+appname+".png")
		var icon = ImageTexture.create_from_image(texture)
		brewicon.set_texture(icon)
		print(appname+" has icon")
	else:
		print(appname+" has no icon")

#Changes if the info or options are on screen based on what state
# the button is when pressed.
func _on_toggled(button_pressed):
	if button_pressed:
		brewinfo.visible= false
		options.visible = true
		download.grab_focus()
	elif not button_pressed:
		closebutton()

func focuscheck():
	var focusdownload = download.has_focus()
	var focussetting = settings.has_focus()
	var focusdelete = delete.has_focus()
	var focusself = self.has_focus()
	if focusdownload or focusdelete or focussetting or focusself:
		print("Check success")
	else:
		print("Check failed")
		genericitem.set_pressed(false)
		options.visible = false

func closebutton():
		brewinfo.visible = true
		options.visible = false

func _on_focus_entered():
	SignalBox.emit_signal("Thisitem", x)
	changeicon(x)
