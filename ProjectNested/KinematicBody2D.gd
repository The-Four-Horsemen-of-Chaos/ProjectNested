extends KinematicBody2D

export (int) var speed = 300
export (int) var jump_speed = -450
export (int) var gravity = 900
export (int) var startHP = 3;
export (float) var hpCooldownTime = 0.3
var hp = 0
var hpCooldown = false 
var isAttacking = false
func get_is_attacking():
	return isAttacking;
var velocity = Vector2.ZERO
var last_wall_direction = 0;

onready var left_wall_raycasts = $WallRaycasts/LeftWallRaycasts
onready var right_wall_raycasts = $WallRaycasts/RightWallRaycasts

func _ready():
	hp = startHP
	
# PHYSICS
func get_input():
	velocity.x = 0
	if Input.is_action_pressed("right"):
		velocity.x += speed
	if Input.is_action_pressed("left"):
		velocity.x -= speed

func _physics_process(delta):
	get_input()
	var wall_direction = get_wall_direction()
	print("wall direction" + str(wall_direction))
	velocity.y += gravity * delta
	
	if is_on_floor():
		if Input.is_action_just_pressed("up"):
			velocity.y = jump_speed
			animation_play("jump")
		else:
			if (abs(velocity.x) > 0.25):
				animation_play("walk")
				$AnimatedSprite.flip_h = velocity.x < 0
			else:
				animation_play("idle")
			
	elif wall_direction != 0:
		animation_play("jump")
		print("WALL")
		$AnimatedSprite.flip_h = wall_direction > 0
		var right = Input.is_action_pressed("right") && wall_direction == -1;
		var left = Input.is_action_pressed("left") && wall_direction == 1;
		print("r" + str(right))
		print("l" + str(left))
		if (right || left):
			print("WALL JUMP")
			velocity.y = jump_speed
			last_wall_direction = 0;
			
		
	if Input.is_action_just_pressed("attack"):
		animation_play("attack")
		isAttacking = true;
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_AnimatedSprite_animation_finished():
	isAttacking = false;

func lose_hp():
	if (!hpCooldown):
		hpCooldown = true;
		hp -= 1;
		if (hp <= 0):
			game_over();
			
		yield(get_tree().create_timer(hpCooldownTime), "timeout");
		hpCooldown = false;
		
func game_over():
	pass
	
func animation_play(clip):
	if (!isAttacking):
		$AnimatedSprite.play(clip)

func check_is_valid_wall(wall_raycasts) -> bool:
	for raycast in wall_raycasts.get_children():
		if raycast.is_colliding():
			return true
			#var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
			#if dot > PI * 0.35 && dot < PI * 0.55:
				#return true
	return false

func get_wall_direction():
	var is_near_wall_left = check_is_valid_wall(left_wall_raycasts)
	var is_near_wall_right = check_is_valid_wall(right_wall_raycasts)
	
	if is_near_wall_left && is_near_wall_right:
		if (velocity.x > 0):
			return 1;
		elif (velocity.x < 0):
			return -1;
		else:
			return 0;
	else:
		return -int(is_near_wall_left) + int(is_near_wall_right)
				
