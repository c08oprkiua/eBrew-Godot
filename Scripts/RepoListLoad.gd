extends Node
@onready var genericitem = preload("res://Scenes/generic_item.tscn")

@export var list: int = 10
var x: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	while x < list:
		add_child(genericitem.instantiate(1))
		x = x + 1
	

