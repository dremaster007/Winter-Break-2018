extends Area2D

export (int) var speed # speed of the enemy

var enemy_lives = 3 # amount of lives

export (PackedScene) var Snowball # export the snowball scene
export (PackedScene) var Snowwall # export the snowwall scene

var screensize # screensize
var velocity = Vector2() # velocity of character moving

var move_up = false # tells whether we move up
var move_down = true # or down

var swapTimeMin = 0.5 # minimum time for random direction swap
var swapTimeMax = 1.5 # maximum time for random direction swap

var enemy_snowball_count = 10 # how many snowballs currently has
var enemy_max_snowball_count = 10 # max number of snowballs

var es # defining the enemy snowball
 
var snowball_position = Vector2() # the snowballs position

var enemy_can_place_wall = true # can enemy place a wall?
var enemy_wall_destroyed = false  # is the wall destroyed?
var wall # instance of the wall

var enemy_state = "high_snow" # sets the enemies state defaulted to high_snow

onready var player = get_parent().get_node("Player") # ease of access for player

func _ready():
	randomize() # random
	get_node("DirectionSwapTimer").start() # start timer for ai direction swapping
	screensize = get_viewport_rect().size # set screensize for clamping

func _process(delta):
	get_parent().get_node("HUD").check_snowball("Enemy", enemy_snowball_count) # update HUD
	check_state(enemy_state) # calls checkstate
	velocity = Vector2(0, 0) # reset velocity
	perform_state(enemy_state) # calls performstate
	print (enemy_state)
	print (velocity)
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
#				move_down = false # move up
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

func velocity_down(direction, state): # called when enemy needs to move
	velocity = Vector2(0, 0)
	if state == "high_snow": # if in high snow
		if direction == true: # if movedown
			velocity.y += 1 # go down
		elif direction == false: # if not
			velocity.y -= 1 # go up
	if state == "low_snow": # if in low snow
		if direction == true: # if movedown
			velocity.y += 1 # go down
		elif direction == false: # if not
			velocity.y -= 1 # go up
	if state == "out_of_snow": # if out of snow
		if direction == true: # if movedown
			velocity.y += 1 # go down
		elif direction == false: # if not
			velocity.y -= 1 # go up

func enemy_attack(state): # ENEMY ATTACKING
	if state == "high_snow": # if state is highsnow
		es = Snowball.instance() # instance a snowball
		es.is_player_snowball = false # make it not a players
		es.start(position, player.position - position, "enemy") # start it
		get_parent().add_child(es) # add it as a child of the main
		get_node("LowSnowAttackTimer").stop() # stop the low attack timer
		get_node("HighSnowAttackTimer").wait_time = rand_range(0.5, 1.0) # randomize the attack timer fire rate
		get_node("HighSnowAttackTimer").start() # start the attack timer
		enemy_snowball_count -= 1 # decrement the snowball count
	elif state == "low_snow": # if in low snow
		es = Snowball.instance() # instance a snowball
		es.is_player_snowball = false # not a player snowball
		es.start(position, player.position - position, "enemy") # start it at enemies position
		get_parent().add_child(es) # add it as a child
		get_node("HighSnowAttackTimer").stop() # stop high attack timer
		get_node("LowSnowAttackTimer").wait_time = rand_range(1.5, 2.0) # randomize the attack timer fire rate
		get_node("LowSnowAttackTimer").start() # start it
		enemy_snowball_count -= 1 #  decrement snowball count
	elif state == "out_of_snow": # if out of snow
		get_node("LowSnowAttackTimer").stop() # stop attack timer
		get_node("HighSnowAttackTimer").stop() # stop attack timer

func enemy_place_wall():
	wall = Snowwall.instance() # spawn in a SNOWWALL
	enemy_wall_destroyed = false # wall dont currently destroyed
	wall.is_player_wall = false # set the snowwall as a player's snowwall
	wall.start(Vector2(position.x - 75, snowball_position.y), true) # place the wall at the enemys global mouse position
	get_parent().add_child(wall) # add the wall as a child of the tree
	enemy_can_place_wall = false # don't let the player place another wall immediatley
	get_node("EnemyWallPlaceTimer").start() # start the timer that will let you place another wall
	get_node("EnemyWallDestroyTimer").start() # set wall self destruction timer

func add_snow(): # when we need to add snow
	if enemy_snowball_count < enemy_max_snowball_count: # if enemy is able to get snowballs
		enemy_snowball_count += 1 # add a snowball

func _on_Enemy_area_entered(area): # if the enemy enters an area
	if area.is_in_group("snowball"): # if the area is a snowball
		if area.is_player_snowball and area.snowball_can_hurt: # if snowball is enabled and is a players
			enemy_lives -= 1 # decrement enemys lives
			get_parent().get_node("HUD").check_lives("Enemy", enemy_lives) # update hud
		if enemy_lives <= 0: # if 0 life
			get_parent().char_die("enemy") # call the die func in main

func _on_SnowballWallCheck_area_entered(area): # if the snowball wall check is triggered
	if area.is_in_group("snowball"): # if its a snowball
		snowball_position = area.position # set the snowballs position as the areas posiiton
		if area.is_player_snowball and area.snowball_can_hurt: # if its a player snowball and is activated
			if enemy_can_place_wall: # and enemy can place a wall
				enemy_place_wall() # call place wall

func _on_TopDodgeCheck_area_entered(area): # if top dodge check
	if area.is_in_group("snowball") and area.is_player_snowball: # if its a snowball and is a player snowball
		get_node("OverrideSpeedTimer").start() # start the override speed timer
		if area.velocity.y > 0: # if the snowball is moving downward
			velocity_down(false, enemy_state) # move up
		elif area.velocity.y <= 0: # if the snowball is moving upward
			velocity_down(true, enemy_state) # move down

func _on_BottomDodgeCheck_area_entered(area): # if bottom dodge check
	if area.is_in_group("snowball") and area.is_player_snowball: # if its a snowball and is a player snowball
		get_node("OverrideSpeedTimer").start() # start the override speed timer
		if area.velocity.y > 0: # if the snowball is moving downward
			velocity_down(true, enemy_state) # move down
		elif area.velocity.y <= 0: # if the snowball is moving upward
			velocity_down(false, enemy_state) # move up

func _on_DirectionSwapTimer_timeout(): # if the directional swap timer times out
	get_node("DirectionSwapTimer").wait_time = rand_range(swapTimeMin, swapTimeMax) # get a random wait time
	if move_down == true: # if we were moving down
		move_down = false # move up
	elif move_down == false: # if we were moving up
		move_down = true # move down

func _on_EnemyWallPlaceTimer_timeout(): # if the enemywallplacetimer times out
	enemy_can_place_wall = true # enemy can now place wall

func _on_EnemyWallDestroyTimer_timeout(): # if wall destroy timer times out
	if enemy_wall_destroyed == false: # if the wall isnt already destroyed
		if wall.is_player_wall == false: # if the wall isnt a player wall
			wall.queue_free() # queue free the wall
	else: # else
		pass # nothing

func _on_HighSnowAttackTimer_timeout(): # if the high snow attack timer
	enemy_attack("high_snow") # attack in high snow state

func _on_LowSnowAttackTimer_timeout(): # if the low snow attack timer
	enemy_attack("low_snow") # attack in low snow state

func _on_OverrideSpeedTimer_timeout(): # this literally does nothing
	speed = 300 # oopsie
