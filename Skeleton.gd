extends KinematicBody2D

const GRAVITY = 10
const SPEED = 30
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var direction = 1
var swapdir = true

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	
	velocity.x = SPEED * direction
	
	if direction == 1:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
		
	$AnimatedSprite.play("Walking")
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_wall():
		direction = direction * -1
		
	if swapdir == true:
		if $RayCast2D.is_colliding() == false:
			direction = direction * -1
			swapdir = false
			$Timer.start()
		
	if get_slide_count() > 0: # Damages the player when the player is standing still.
		for i in range(get_slide_count()):
			if "movable" in get_slide_collision(i).collider.name:
				direction = direction * -1
			if "Player" in get_slide_collision(i).collider.name:
				if get_slide_collision(i).collider.immune == false:
					get_slide_collision(i).collider.damage(25)
					print("Enemy damage")
				else:
					print("Immune") 


func _on_Timer_timeout():
	swapdir = true
