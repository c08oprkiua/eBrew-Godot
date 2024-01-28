extends VBoxContainer

@onready var brewlore = $BrewLore
@onready var brewicon = $IconCorrector/BrewIcon
var settingswindow = preload("res://Scenes/settings.tscn")
@onready var localx: int
var empty

func _ready():
	SignalBox.connect("Thisitem", updateinfo)
	SignalBox.connect("Processedicon", updooticon)

func updateinfo(arg1):
	localx = arg1
	changetext()
	updooticon(empty)

func changetext():
	brewlore.text = BrewInfo.Information.packages[localx].details.replace("\\n", "\n")
	#credit to @traceentertains on Discord for figuring out how to get the text to format properly

func updooticon(_arg1):
	brewicon.set_texture(BrewInfo.Icon)

#This is hacky, I would like to make it better
func _on_settings_pressed():
	BrewInfo.filesyscheck()
	if get_child_count() > 3:
		get_child(3).show()
	else:
		add_child(settingswindow.instantiate(),false, Node.INTERNAL_MODE_DISABLED)
