extends VBoxContainer

func _ready() -> void:
	#SignalBox.connect("SafeRepo", ProceedLoadList)
	SignalBox.connect("SafeRepo", newloadlist)

func ProceedLoadList() -> void:
	const genericitem:PackedScene = preload("res://Scenes/generic_item.tscn")
	if get_child_count() > 0:
		for child in get_children():
			remove_child(child)
	var list:int = BrewInfo.Information.packages.size()
	for i:int in range(0, list):
		add_child(genericitem.instantiate())
		SignalBox.emit_signal("InitDir", i)

func newloadlist() -> void:
	const genericitem:PackedScene = preload("res://Scenes/new_generic_item.tscn")
	if get_child_count() > 0:
		for children in get_children():
			remove_child(children)
	var list: int = BrewInfo.Information.packages.size()
	for items:int in range(0, list):
		var infodict:Dictionary = BrewInfo.Information.packages[items]
		var item:HBASAppInfo = HBASAppInfo.new(infodict)
		if FileAccess.file_exists(item.get_save_directory()):
			item = ResourceLoader.load(item.get_save_directory(), "HBASAppInfo")
		var new_entry:GenericItem = genericitem.instantiate()
		add_child(new_entry)
		new_entry.myinfo = item
		
