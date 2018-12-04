extends Area2D

var velocity = Vector2(0, 0) # We set this velocity in the main script

export (int) var speed


func start(pos, mousey):
	position = pos
	velocity = Vector2(speed, mousey)

func _process(delta):
	position += velocity * delta
	if position.x > get_parent().get_node("Player").screensize.x * .95:
		queue_free()