extends Area2D

signal game_over

export (int) var speed # how fast player walks
var velocity = Vector2() # walking velocity
var screensize = Vector2() # screensize 

var wall_destroyed = false # 
var is_player_wall = true

var player_throw = false

var mouse_position = Vector2(0, 0)
var global_mouse_position = Vector2(0, 0)

func _ready():
	screensize = get_viewport_rect().size
	get_node("Sprite/AnimationPlayer").current_animation = "idle"

func _process(delta):
	mouse_position = get_local_mouse_position()
	global_mouse_position = get_global_mouse_position()
	if velocity.y == 0:
		get_node("Sprite/AnimationPlayer").current_animation = "idle"
	get_input()
	position.y = clamp(position.y, screensize.y * .1, screensize.y * .9)
	position += velocity * delta * speed

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		get_node("Sprite/AnimationPlayer").current_animation = "walking_up"
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		get_node("Sprite/AnimationPlayer").current_animation = "walking_down"

func die():
	emit_signal("game_over")

func _on_Player_area_entered(area):
	if area.is_in_group("snowball") and area.is_player_snowball == false:
		die()













