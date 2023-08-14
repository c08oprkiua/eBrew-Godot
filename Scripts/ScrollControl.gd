extends MarginContainer

@export var data : BrewInfo
@onready var scroll = $VBoxContainer/Scroll



func _ready():
	SignalBox.connect("StartList", Initialize)
	SignalBox.connect("Thisitem", UpdatePosition)

func Initialize():
	scroll.max_value = data.Information.packages.size()

func UpdatePosition(here):
	scroll.set_value(here)

func _on_page_up_pressed():
	scroll.set_value(scroll.get_value()-4)
	ScrollPos()

func _on_page_down_pressed():
	scroll.set_value(scroll.get_value()+4)
	ScrollPos()

func _on_scroll_position_changed():
	ScrollPos()

func _on_scroll_scrolling():
	ScrollPos()

func ScrollPos():
	SignalBox.emit_signal("Gohere", scroll.get_value())
