extends Area2D

export (int) var speed # speed of the enemy

var screensize # screensize
var velocity = Vector2() # velocity of character moving

var move_up = false # tells whether we move up
var move_down = true # or down

var swapTimeMin = 0.5 # minimum time for random direction swap
var swapTimeMax = 1.5 # maximum time for random direction swap

func _ready():
	randomize()
	get_node("DirectionSwapTimer").start() # start timer for ai swapping
	screensize = get_viewport_rect().size # set screensize for clamping

func _process(delta):
	velocity = Vector2() # reset velocity
	
	if move_down == true: # moving down
		velocity.y += 1
	if move_up == true: # moving up
		velocity.y -= 1
	position += velocity * delta * speed # increase velocity
	position.y = clamp(position.y, screensize.y * .1, screensize.y * .9) # clamp the enemy

func _on_DirectionSwapTimer_timeout():
	get_node("DirectionSwapTimer").wait_time = rand_range(swapTimeMin, swapTimeMax)
	if move_down == true:
		move_down = false
		move_up = true
	elif move_up == true:
		move_up = false
		move_down = true

