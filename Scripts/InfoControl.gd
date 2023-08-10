extends VSplitContainer

@onready var brewlore = $BrewLore
@onready var brewicon = $IconCorrector/BrewIcon
@export var data : BrewInfo
var settingswindow = preload("res://Scenes/settings.tscn")

@onready var localx
var empty

func _ready():
	SignalBox.connect("Thisitem", updateinfo)
	SignalBox.connect("Processedicon", updooticon)

func updateinfo(arg1):
	localx = arg1
	changetext()
	#I have no clue why, but passing this empty var makes it update properly
	updooticon(empty)

func changetext():
	brewlore.text = data.Information.packages[localx].details.replace("\\n", "\n")
	#credit to @traceentertains on Discord for figuring out how to get the text to format properly

func updooticon(arg1):
	$IconCorrector/BrewIcon.set_texture(data.Icon)

func _on_settings_pressed():
	data.filesyscheck()
	if get_child_count() > 2:
		get_child(2).show()
	else:
		add_child(settingswindow.instantiate(),false, Node.INTERNAL_MODE_DISABLED)
