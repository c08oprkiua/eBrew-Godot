extends TextureButton

# We define the nodes so we can interact with them
@onready var options = get_node("OptionContainer")
@onready var brewinfo = get_node("InfoContainer")
@onready var genericitem = get_node(".")
@onready var delete = get_node("OptionContainer/Delete")
@onready var download = get_node("OptionContainer/Download")
@onready var settings = get_node("OptionContainer/Settings")


func _ready():
	$OptionContainer.visible = false
	$InfoContainer.visible = true

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
	if has_focus() != focusdownload or focusdelete or focussetting:
		genericitem.set_pressed(false)
		options.visible = false

#I had to move the function that closes options when unselected because it used 
#a Viewport method
func _on_focus_exited():
	focuscheck()

func _on_download_focus_exited():
	focuscheck()

func _on_settings_focus_exited():
	focuscheck()

func _on_delete_focus_exited():
	focuscheck()
