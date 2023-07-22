extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists("res://Userfiles/background.png"):
		var bg = Image.load_from_file("res://Userfiles/background.png")
		var userbg = ImageTexture.create_from_image(bg)
		$BrewBackground.set_texture(userbg)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
