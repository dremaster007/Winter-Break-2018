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

var enemy_snowball_count = 10
var enemy_max_snowball_count = 10

var es # defining the enemy snowball

var snowball_position = Vector2()

var enemy_can_place_wall = true
var enemy_wall_destroyed = false 
var wall

var enemy_state = "high_snow" # sets the enemies state

onready var player = get_parent().get_node("Player") # ease of access for player

func _ready():
	randomize()
	get_node("DirectionSwapTimer").start() # start timer for ai swapping
	screensize = get_viewport_rect().size # set screensize for clamping

func _process(delta):
	#print(enemy_snowball_count) # prints out how many snowballs the enemy has
	check_state(enemy_state) # calls checkstate
	velocity = Vector2(0, 0) # reset velocity
	perform_state(enemy_state) # calls performstate
	position += velocity * delta * speed # increase velocity
	position.y = clamp(position.y, screensize.y * .1, screensize.y * .9) # clamp the enemy

# This fumction takes in the current state of the enemy ai
# and determines what state it should actually be in depending on
# it's variables, like amount of snow, etc
func check_state(state):
	if state == "high_snow": # if enemy state is "high_snow"
		if enemy_snowball_count < enemy_max_snowball_count * 0.6: # check to see snowcount is 3 or less
			enemy_state = "low_snow" # set state to low_snow
	elif state == "low_snow": # otherwise if state is "low_snow"
		if enemy_snowball_count == 0: # check to see if the enemy's snowball count is 0
			enemy_state = "out_of_snow" # set state to out_of_snow
		elif enemy_snowball_count > enemy_max_snowball_count * 0.6: # but if snowball count is > 3
			enemy_state = "high_snow" # set state to high_snow
	elif state == "out_of_snow": # otherwise if state is "out_of_snow"
		if enemy_snowball_count > 0: # check to see if snowball count is greater than 0
			enemy_state = "low_snow" # set state to low_snow

# This function will perform was has to happen during each state
# that the ai is in
func perform_state(state):
	match state:
		"high_snow": # if enemy is high snow state
			enemy_move("high_snow") # move the enemy in the specific way
			if get_node("HighSnowAttackTimer").is_stopped(): # if the high snow attack timer is stopped
				get_node("HighSnowAttackTimer").start() # start it
				get_node("LowSnowAttackTimer").stop() # stop the low attack timer
		"low_snow": # if the enemy is at low snow state
			enemy_move("low_snow") # move the enemy in the specific way
			if get_node("LowSnowAttackTimer").is_stopped(): # if the low snow attack timer is stopped
				get_node("LowSnowAttackTimer").start() # start it
				get_node("HighSnowAttackTimer").stop() # stop the high snow attack timer
		"out_of_snow": # if the enemy is at outofsnow state
			enemy_move("out_of_snow") # move the enemy in the specific way
			get_node("LowSnowAttackTimer").stop() # stop the low attack timer
			get_node("HighSnowAttackTimer").stop() # stop the high attack timer

func enemy_move(state):
	if state == "high_snow": # if state is highsnow
		if get_node("DirectionSwapTimer").is_stopped(): # if direction swap timer is stopped
			get_node("DirectionSwapTimer").start() # then start it
		if player.snowball_count <= 1:
			if position.y > screensize.y / 2: # if the enemy is in the lower half of the screen
				move_down = true # move down
				velocity_down(true, state) # call velocity down while moving down
			elif position.y <= screensize.y / 2: # if the enemy is in the top half of the screen
				move_down = false # move up
				velocity_down(false, state) # call velocity with move up
		if move_down == true: # if move down is true
			velocity_down(true, state) # call velocity_down, sending it the direciton and state
		elif move_down == false: # otherwise if move down is false
			velocity_down(false, state) # call velocity_down with different params
	if state == "low_snow": # if state is lowsnow
		if get_node("DirectionSwapTimer").is_stopped(): # if the direction swap timer is stopped
			get_node("DirectionSwapTimer").start() # then start it
		if player.snowball_count <= 1:
			if position.y > screensize.y / 2: # if the enemy is in the lower half of the screen
				move_down = true # move down
				velocity_down(true, state) # call velocity down while moving down
			elif position.y <= screensize.y / 2: # if the enemy is in the top half of the screen
				move_down = false # move up
				velocity_down(false, state) # call velocity with move up
		if move_down == true: # if move down is true
			velocity_down(true, state) # call velocity down with move down and lowsnow
		elif move_down == false: # otherwise if move down is false
			velocity_down(false, state) # call velocitydown with movedonw and lowsnow
	if state == "out_of_snow": # if state is outofsnow
		if position.y > screensize.y / 2: # if the enemy is in the lower half of the screen
			move_down = true # move down
			velocity_down(true, state) # call velocity down while moving down
		elif position.y <= screensize.y / 2: # if the enemy is in the top half of the screen
			move_down = false # move up
			velocity_down(false, state) # call velocity with move up

func velocity_down(direction, state):
	if state == "high_snow":
		if direction == true:
			velocity.y += 1
		elif direction == false:
			velocity.y -= 1
	if state == "low_snow":
		if direction == true:
			velocity.y += 1
		elif direction == false:
			velocity.y -= 1
	if state == "out_of_snow":
		if direction == true:
			velocity.y += 1
		elif direction == false:
			velocity.y -= 1

func enemy_attack(state):
	print(state, "<----- Enemy attack state")
	if state == "high_snow": # if state is highsnow
		es = Snowball.instance() # instance a snowball
		es.is_player_snowball = false # make it not a players
		es.start(position, player.position - position, "enemy") # start it
		get_parent().add_child(es) # add it as a child of the main
		get_node("LowSnowAttackTimer").stop() # stop the low attack timer
		get_node("HighSnowAttackTimer").wait_time = rand_range(0.5, 1.0)
		get_node("HighSnowAttackTimer").start()
		enemy_snowball_count -= 1
	elif state == "low_snow":
		es = Snowball.instance()
		es.is_player_snowball = false
		es.start(position, player.position - position, "enemy")
		get_parent().add_child(es)
		get_node("HighSnowAttackTimer").stop()
		get_node("LowSnowAttackTimer").wait_time = rand_range(1.5, 2.0)
		get_node("LowSnowAttackTimer").start()
		enemy_snowball_count -= 1
	elif state == "out_of_snow":
		#es = Snowball.instance()
		#es.is_player_snowball = false
		#es.start(position, player.position - position, "enemy")
		#get_parent().add_child(es)
		get_node("LowSnowAttackTimer").stop()
		get_node("HighSnowAttackTimer").stop()

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

func _on_Enemy_area_entered(area):
	pass
	# this will do stuff when the enemy is hit with a player snowball or dies of other reasons

func _on_SnowballWallCheck_area_entered(area):
	if area.is_in_group("snowball"):
		snowball_position = area.position
		if area.is_player_snowball:
			if enemy_can_place_wall:
				enemy_place_wall()

func _on_TopDodgeCheck_area_entered(area):
	if area.is_in_group("snowball") and area.is_player_snowball:
		get_node("OverrideSpeedTimer").start()
		if area.velocity.y > 0:
			speed = 600
			velocity_down(false, enemy_state)
		elif area.velocity.y <= 0:
			speed = 600
			velocity_down(true, enemy_state)

func _on_BottomDodgeCheck_area_entered(area):
	if area.is_in_group("snowball") and area.is_player_snowball:
		get_node("OverrideSpeedTimer").start()
		if area.velocity.y > 0:
			speed = 600
			velocity_down(true, enemy_state)
		elif area.velocity.y <= 0:
			speed = 600
			velocity_down(false, enemy_state)

func _on_DirectionSwapTimer_timeout():
	get_node("DirectionSwapTimer").wait_time = rand_range(swapTimeMin, swapTimeMax)
	if move_down == true:
		move_down = false
	elif move_down == false:
		move_down = true

func _on_EnemyWallPlaceTimer_timeout():
	enemy_can_place_wall = true

func _on_EnemyWallDestroyTimer_timeout():
	if enemy_wall_destroyed == false:
		if wall.is_player_wall == false:
			wall.queue_free()
	else:
		pass

func _on_HighSnowAttackTimer_timeout():
	enemy_attack("high_snow")

func _on_LowSnowAttackTimer_timeout():
	enemy_attack("low_snow")

func _on_OverrideSpeedTimer_timeout():
	speed = 300
