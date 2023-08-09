extends Node
var genericitem = preload("res://Scenes/generic_item.tscn")
@export var data : BrewInfo

func _ready():
	SignalBox.connect("SafeRepo", ProceedLoadList)
	SignalBox.connect("StartList", InitialLoadList)

func InitialLoadList():
	data.JSONdecoding()

func ProceedLoadList():
	var list = data.Information.packages.size()
	for i in range(0, list):
		add_child(genericitem.instantiate())
		SignalBox.emit_signal("InitDir", i)
