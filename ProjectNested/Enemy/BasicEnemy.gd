extends Area2D

var direction = 1;
var previous_direction = 0;
var hp = 0;
export var speed = 200;
export var minX = 0;
export var maxX = 200;
export var startHP = 3;

var touching_player = false
# Called when the node enters the scene tree for the first time.
func getDir():
	match(direction):
		0:
			return previous_direction
		_:
			return direction

func setDir(value):
	previous_direction = direction
	direction = value

func _ready():
	position.x = minX;
	
func _physics_process(delta):
	if (position.x < minX):
		setDir(1);
	elif (position.x > maxX):
		setDir(-1);
	position += Vector2(speed * direction * delta, 0);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Area2D_body_entered(body):
	if (body.name == "Player"):
		touching_player = true;
		

func _on_Area2D_body_exited(body):
	if (body.name == "Player"):
		touching_player = false;

func attack():
	setDir(0);
	# NOT IMPLEMENTED
	pass

func lose_health():
	
	hp -= 1;
	if (hp < 0):
		die();
	
	setDir(getDir() * -1);
	yield(get_tree().create_timer(1), "timeout");
	setDir(0);
	yield(get_tree().create_timer(1), "timeout");
	setDir(getDir() * -2);

func die():
	queue_free();
