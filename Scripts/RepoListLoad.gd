extends Node
const genericitem = preload("res://Scenes/generic_item.tscn")

func _ready():
	SignalBox.connect("SafeRepo", ProceedLoadList)

func ProceedLoadList() -> void:
	if get_child_count() > 0:
		for child in get_children():
			remove_child(child)
	var list:int = BrewInfo.Information.packages.size()
	for i:int in range(0, list):
		add_child(genericitem.instantiate())
		SignalBox.emit_signal("InitDir", i)

func newloadlist() -> void:
	if get_child_count() > 0:
		for children in get_children():
			remove_child(children)
	var list: int = BrewInfo.Information.packages.size()
	for items:int in range(0, list):
		var item: AppInfo = AppInfo.new()
		var infodict: Dictionary = BrewInfo.Information.packages[items]
