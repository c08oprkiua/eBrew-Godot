extends VSplitContainer

@onready var brewlore = $BrewLore
@onready var brewicon = $IconCorrector/BrewIcon
@export var data : BrewInfo

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBox.connect("CurrentDir",changetext)

func changetext(arg1):
	brewlore.text = data.Information.packages[arg1].details
