extends KinematicBody2D

export (int) var speed = 200
export var gravity = 33;
export var maxGravity = 500
export var jumpSpeed = -700.0

var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('up'):
		velocity.y -= 2
	velocity.y += 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	move_and_slide(velocity, Vector2.UP, false, 4, 0.785398, false)
	
