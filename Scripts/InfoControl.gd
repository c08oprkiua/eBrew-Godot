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
		#WIP check for a child so it doesn't load infinite settings windows on every press
	data.filesyscheck()
	print($BrewLore/Settings.get_child_count())
	if $BrewLore/Settings.get_child_count() > 0:
		print($BrewLore/Settings.get_children())
	else:
		add_child(settingswindow.instantiate())
