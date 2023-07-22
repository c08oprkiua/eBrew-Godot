extends Viewport

@onready var genericitem = get_node(".")
@onready var delete = get_node("OptionContainer/Delete")
@onready var download = get_node("OptionContainer/Download")
@onready var settings = get_node("OptionContainer/Settings")
@onready var options = get_node("OptionContainer")

func _on_generic_item_focus_exited():
	var focusedthing = gui_get_focus_owner()
	if focusedthing!= download or delete or settings:
		genericitem.set_pressed(false)
		options.visible = false
