extends Area2D

var move_enemy # 0 = move down, 1 = move up
var velocity = Vector2(0, 0) # We set this velocity in the main script

export (int) var speed

export var is_player_snowball = true

func start(pos, target, character):
	position = pos
	if character == "player":
		is_player_snowball = true
		velocity = Vector2(speed, target)
	elif character == "enemy":
		is_player_snowball = false
		velocity = Vector2(-speed, target)

func _process(delta):
	position += velocity * delta
	if position.x > get_parent().get_node("Player").screensize.x * .95:
		queue_free()
