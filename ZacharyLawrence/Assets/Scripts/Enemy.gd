extends Area2D

export (int) var speed # speed of the enemy

export (PackedScene) var Snowball
export (PackedScene) var Snowwall # export the snowwall scene

var screensize # screensize
var velocity = Vector2() # velocity of character moving

var move_up = false # tells whether we move up
var move_down = true # or down

var swapTimeMin = 0.5 # minimum time for random direction swap
var swapTimeMax = 1.5 # maximum time for random direction swap

var enemy_snowball_count = 5
var enemy_max_snowball_count = 5

var es # defining the enemy snowball

var snowball_position = Vector2()

var enemy_can_place_wall = true
var enemy_wall_destroyed = false 
var wall

var enemy_state = "high_snow"

onready var player = get_parent().get_node("Player") # ease of access for player

func _ready():
	randomize()
	get_node("DirectionSwapTimer").start() # start timer for ai swapping
	screensize = get_viewport_rect().size # set screensize for clamping

func _process(delta):
	check_state(enemy_state)
	perform_state(enemy_state)
	print (enemy_state)
	velocity = Vector2() # reset velocity
	if move_down == true: # moving down
		velocity.y += 1
	if move_up == true: # moving up
		velocity.y -= 1
	position += velocity * delta * speed # increase velocity
	position.y = clamp(position.y, screensize.y * .1, screensize.y * .9) # clamp the enemy


# This fumction takes in the current state of the enemy ai
# and determines what state it should actually be in depending on
# it's variables, like amount of snow, etc
func check_state(state):
	if state == "high_snow": # if enemy state is "high_snow"
		if enemy_snowball_count < enemy_max_snowball_count - 2: # check to see snowcount is 3 or less
			enemy_state = "low_snow" # set state to low_snow
	elif state == "low_snow": # otherwise if state is "low_snow"
		if enemy_snowball_count == 0: # check to see if the enemy's snowball count is 0
			enemy_state = "out_of_snow" # set state to out_of_snow
		elif enemy_snowball_count > enemy_max_snowball_count - 2: # but if snowball count is > 3
			enemy_state = "high_snow" # set state to high_snow
	elif state == "out_of_snow": # otherwise if state is "out_of_snow"
		if enemy_snowball_count > 0: # check to see if snowball count is greater than 0
			enemy_state = "low_snow" # set state to low_snow

func perform_state(state):
	match state:
		"high_snow":
			pass
		"low_snow":
			pass
		"out_of_snow":
			pass

func _on_DirectionSwapTimer_timeout():
	get_node("DirectionSwapTimer").wait_time = rand_range(swapTimeMin, swapTimeMax)
	if move_down == true:
		move_down = false
		move_up = true
	elif move_up == true:
		move_up = false
		move_down = true

func enemy_attack():
	es = Snowball.instance() # spawn in a SNOWBALL
	es.is_player_snowball = false # set the snowball as not a player
	es.start(position, player.position - position, "enemy") # start the snowball at the enemy, moving towards the player
	get_parent().add_child(es) # add it as a child 
	#enemy_can_attack = false # don't let the enemy attack immediately
	get_node("EnemyAttackTimer").wait_time = rand_range(0.5, 1.0) # randomize when the enemy will shoot
	get_node("EnemyAttackTimer").start() # start the enemy shooting timer
	enemy_snowball_count -= 1

func enemy_place_wall():
	wall = Snowwall.instance() # spawn in a SNOWWALL
	enemy_wall_destroyed = false
	wall.is_player_wall = false # set the snowwall as a player's snowwall
	wall.start(Vector2(position.x - 75, snowball_position.y)) # place the wall at the enemys global mouse position
	get_parent().add_child(wall) # add the wall as a child of the tree
	enemy_can_place_wall = false # don't let the player place another wall immediatley
	get_node("EnemyWallPlaceTimer").start() # start the timer that will let you place another wall
	get_node("EnemyWallDestroyTimer").start() # set wall self destruction timer

func add_snow():
	if enemy_snowball_count < enemy_max_snowball_count:
		enemy_snowball_count += 1

func _on_EnemyAttackTimer_timeout():
	if enemy_snowball_count > 0:
		enemy_attack()

func _on_Enemy_area_entered(area):
	pass
	# this will do stuff when the enemy is hit with a player snowball or dies of other reasons

func _on_SnowballWallCheck_area_entered(area):
	if area.is_in_group("snowball"):
		snowball_position = area.position
		if area.is_player_snowball:
			if enemy_can_place_wall:
				enemy_place_wall()

func _on_EnemyWallPlaceTimer_timeout():
	enemy_can_place_wall = true

func _on_EnemyWallDestroyTimer_timeout():
	if enemy_wall_destroyed == false:
		if wall.is_player_wall == false:
			wall.queue_free()
	else:
		pass

