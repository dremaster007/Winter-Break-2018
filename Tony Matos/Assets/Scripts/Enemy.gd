extends Area2D

export (int) var speed
var velocity = Vector2(0, 0)
var screensize = Vector2()

export (float) var max_wait

var min_move
var max_move

var can_move_enemy = true

func _ready():
	randomize()
	screensize = get_viewport_rect().size
	min_move = position.y - 200
	max_move = position.y + 200

func _process(delta):
	position.y = clamp(position.y, screensize.y * .1, screensize.y * .9)
	move_enemy()


func move_enemy():
	if can_move_enemy:
		position.y += rand_range(min_move, max_move)
		can_move_enemy = false
		get_node("MoveEnemyTimer").wait_time = rand_range(0.5, 3)
		get_node("MoveEnemyTimer").start()


func _on_MoveEnemyTimer_timeout():
	can_move_enemy = true
