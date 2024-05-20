extends VBoxContainer

@onready var brewlore:RichTextLabel = $BrewLore
@onready var brewicon:TextureRect = $IconCorrector/BrewIcon
var settingswindow:PackedScene = preload("res://Scenes/settings.tscn")
@onready var localx: int
var empty

func _ready() -> void:
	SignalBox.connect("Thisitem", updateinfo)
	SignalBox.connect("Processedicon", updooticon)

func updateinfo(arg1) -> void:
	localx = arg1
	changetext()
	updooticon(empty)

func changetext() -> void:
	brewlore.text = BrewInfo.Information.packages[localx].details.replace("\\n", "\n")
	#credit to @traceentertains on Discord for figuring out how to get the text to format properly

func updooticon(_arg1) -> void:
	brewicon.set_texture(BrewInfo.Icon)

#This is hacky, I would like to make it better
func _on_settings_pressed() -> void:
	BrewInfo.filesyscheck()
	if get_child_count() > 3:
		get_child(3).show()
	else:
		add_child(settingswindow.instantiate(), false, Node.INTERNAL_MODE_DISABLED)
