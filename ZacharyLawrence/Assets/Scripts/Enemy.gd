extends Area2D

export (int) var speed

var screensize
var velocity = Vector2()

var move_up = false
var move_down = true

var swapTimeMin = 0.5
var swapTimeMax = 1.5

func _ready():
	randomize()
	get_node("DirectionSwapTimer").start()
	screensize = get_viewport_rect().size

func _process(delta):
	velocity = Vector2()
	if move_down == true:
		velocity.y += 1
	if move_up == true:
		velocity.y -= 1
	position += velocity * delta * speed
	position.y = clamp(position.y, screensize.y * .1, screensize.y * .9)

func _on_DirectionSwapTimer_timeout():
	get_node("DirectionSwapTimer").wait_time = rand_range(swapTimeMin, swapTimeMax)
	if move_down == true:
		move_down = false
		move_up = true
	elif move_up == true:
		move_up = false
		move_down = true