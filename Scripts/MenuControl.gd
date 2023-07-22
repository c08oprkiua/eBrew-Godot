extends TextureButton

@onready var optioncontainer = get_node("ScrollContainer/List/GenericItem/OptionContainer")
@onready var genericitem = get_node("ScrollContainer/List/GenericItem")

func _ready():
	$OptionContainer.visible = false

func _process(delta):
	# We define the nodes so we can interact with them
	optioncontainer = get_node("ScrollContainer/List/GenericItem/OptionContainer")
	genericitem = get_node("ScrollContainer/List/GenericItem")

func _on_toggled(button_pressed):
	if button_pressed:
		$OptionContainer.visible = true
	else:
		$OptionContainer.visible=false

