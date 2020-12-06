extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var max_viewing_distance = Vector2(500,256);
export var minX = 0;
export var maxX = 200;
var direction = 1;
export var speed = 200;

onready var player = get_tree().get_root().get_node("Node2D").get_node("player")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!is_player_visible()):
		$AnimatedSprite.play("idle")
	else:
		$AnimatedSprite.flip_h = direction < 0
		$AnimatedSprite.play("walk")

func _physics_process(delta):
	if (is_player_visible()): # LATER IMPLEMENT PLAYER PHEREMONES
		position += Vector2(speed * direction * delta, 0);


func is_player_visible():
	var if_visible_x = abs(player.position.x - position.x) < max_viewing_distance.x
	var if_visible_y = player.position.y >= position.y && (player.position.y - position.y) < max_viewing_distance.y
	
	if if_visible_x && if_visible_y:
		match(direction):
			1:
				return player.position.x > position.x;
			-1:
				return player.position.x < position.x;
			_:
				return true;
			
		
	else:
		return false;


func _on_DirectionTimer_timeout():
	if (not is_player_visible()):
		direction *= -1;


func _on_Guardiant_body_entered(body):
	body.game_over()
