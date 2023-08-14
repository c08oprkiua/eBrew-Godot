extends Node
var genericitem = preload("res://Scenes/generic_item.tscn")
@export var data : BrewInfo

func _ready():
	SignalBox.connect("SafeRepo", ProceedLoadList)
	SignalBox.connect("StartList", InitialLoadList)

func InitialLoadList():
	data.JSONdecoding()

func ProceedLoadList():
	if get_child_count() > 0:
		for child in get_children():
			remove_child(child)
	var list = data.Information.packages.size()
	for i in range(0, list):
		add_child(genericitem.instantiate())
		SignalBox.emit_signal("InitDir", i)
