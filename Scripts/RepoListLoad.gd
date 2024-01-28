extends Node
var genericitem = preload("res://Scenes/generic_item.tscn")

func _ready():
	SignalBox.connect("SafeRepo", ProceedLoadList)

func ProceedLoadList():
	if get_child_count() > 0:
		for child in get_children():
			remove_child(child)
	var list = BrewInfo.Information.packages.size()
	for i in range(0, list):
		add_child(genericitem.instantiate())
		SignalBox.emit_signal("InitDir", i)

func newloadlist():
	if get_child_count() > 0:
		for children in get_children():
			remove_child(children)
	var list: int = BrewInfo.Information.packages.size()
	for items in range(0, list):
		var item: AppInfo = AppInfo.new()
		var infodict: Dictionary = BrewInfo.Information.packages[items]
