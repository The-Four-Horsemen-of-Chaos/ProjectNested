extends Area2D

var direction = 1;
var previous_direction = 0;
var hp = 0;
export var speed = 200;
export var freak_out_speed_multiplier = 2;
export var minX = 0;
export var maxX = 200;
export var startHP = 3;

var touching_player = false
var freak_out = false
var attacking = false
onready var player = get_tree().get_root().get_node("Node2D").get_node("player")

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
	hp = startHP
	
func _physics_process(delta):
	if (position.x < minX):
		setDir(1);
	elif (position.x > maxX):
		setDir(-1);
	var velocity = Vector2(speed * direction * delta, 0);
	if (freak_out):
		velocity.x *= freak_out_speed_multiplier;
	position += velocity;
	
	if (touching_player && player.get_is_attacking()):
		lose_health()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Area2D_body_entered(body):
	if (body.name == "player"):
		attack()
		touching_player = true;
		

func _on_Area2D_body_exited(body):
	if (body.name == "player"):
		touching_player = false;

func attack():
	if (!attacking):
		attacking = true;
		setDir(0);
		player.lose_hp()
		yield(get_tree().create_timer(1), "timeout");
		setDir(getDir());
		yield(get_tree().create_timer(5), "timeout");
		attacking = false;

func lose_health():
	if (!freak_out):
		freak_out = true;
		
		hp -= 1;
		if (hp < 0):
			die();
		
		
		yield(get_tree().create_timer(1), "timeout");
		freak_out = false;

func die():
	queue_free();
