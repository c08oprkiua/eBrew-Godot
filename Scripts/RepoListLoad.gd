extends Node
var genericitem = preload("res://Scenes/generic_item.tscn")
var x: int = 0
@export var data : BrewInfo

func _on_list_load_pressed():
	data.JSONdecoding()
	var list = data.Information.packages.size()
	print(data.Information.packages.size())
	while x < list:
		print("Number ", x ,": ", data.Information.packages[x].title)
		SignalBox.emit_signal("InitDir", x)
		var listing = genericitem.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		add_child(listing)
		x = x + 1

