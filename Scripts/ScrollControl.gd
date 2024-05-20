extends PanelContainer

@onready var scroll:VScrollBar = $VBoxContainer/Scroll

func _ready() -> void:
	SignalBox.connect("SafeRepo", Initialize)
	SignalBox.connect("Thisitem", UpdatePosition)

func Initialize() -> void:
	scroll.max_value = BrewInfo.Information.packages.size()

func UpdatePosition(here) -> void:
	scroll.set_value(here)

func _on_page_up_pressed() -> void:
	scroll.set_value(scroll.get_value()-4)
	ScrollPos()

func _on_page_down_pressed() -> void:
	scroll.set_value(scroll.get_value()+4)
	ScrollPos()

func _on_scroll_position_changed(_value) -> void:
	ScrollPos()

func _on_scroll_scrolling() -> void:
	ScrollPos()

func ScrollPos() -> void:
	SignalBox.emit_signal("Gohere", scroll.get_value())
