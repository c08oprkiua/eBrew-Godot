extends Node
var genericitem = preload("res://Scenes/generic_item.tscn")
var x
@export var data : BrewInfo

func _on_list_load_pressed():
	data.JSONdecoding()
	var list = data.Information.packages.size()
	#add something that subtracts 1 from the list, right now its creating a null list that 
	#crashes the program, we don't want that
	print(list)
	x = 0
	while x < list:
		#print("Number ", x ,": ", data.Information.packages[x].title)
		SignalBox.emit_signal("InitDir", x)
		var listing = genericitem.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		add_child(listing)
		x = x + 1

