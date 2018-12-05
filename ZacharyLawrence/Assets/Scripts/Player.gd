extends Area2D

export (int) var speed
var velocity = Vector2()
var screensize = Vector2()

var wall_destroyed = false
var is_player_wall = true

var mouse_position = Vector2(0, 0)
var global_mouse_position = Vector2(0, 0)

func _ready():
	screensize = get_viewport_rect().size

func _process(delta):
	mouse_position = get_local_mouse_position()
	global_mouse_position = get_global_mouse_position()
	get_input()
	position.y = clamp(position.y, screensize.y * .1, screensize.y * .9)
	position += velocity * delta * speed

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1