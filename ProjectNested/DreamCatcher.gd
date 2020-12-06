extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var hp_0 = load("res://Assets/DreamCatcher/hp-0.png")
onready var hp_1 = load("res://Assets/DreamCatcher/hp-1.png")
onready var hp_2 = load("res://Assets/DreamCatcher/hp-2.png")
onready var hp_3 = load("res://Assets/DreamCatcher/hp-3.png")
onready var player = get_tree().get_root().get_node("Node2D").get_node("player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	match(player.get_hp()):
		0:
			texture = hp_0
		1:
			texture = hp_1
		2:
			texture = hp_2
		3:
			texture = hp_3
		_:
			texture = hp_0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
