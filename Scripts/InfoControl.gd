extends VSplitContainer

@onready var brewlore = $BrewLore
@onready var brewicon = $IconCorrector/BrewIcon
@export var data : BrewInfo

func _ready():
	SignalBox.connect("Thisitem", updateinfo)
	SignalBox.connect("Okaytoloadimg", changeicon)

func updateinfo(arg1):
	changetext(arg1)
	changeicon(arg1)

func changetext(arg1):
	brewlore.text = data.Information.packages[arg1].details
	var appname = data.Information.packages[arg1].name

func changeicon(arg1):
	var appname = data.Information.packages[arg1].name
	if FileAccess.file_exists("res://Userfiles/Icons/"+appname+".png"):
		var texture = Image.load_from_file("res://Userfiles/Icons/"+appname+".png")
		var icon = ImageTexture.create_from_image(texture)
		$IconCorrector/BrewIcon.set_texture(icon)
	else:
		SignalBox.emit_signal("DLicon", arg1)

