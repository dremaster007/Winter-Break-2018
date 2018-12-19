extends Area2D

#signal game_over

export (PackedScene) var Snowball # export the snowball scene
export (PackedScene) var Snowwall # export the snowwall scene

export (AudioStream) var PlayerHit1
export (AudioStream) var PlayerHit2
export (AudioStream) var PlayerHit3

var lives = 3

export (int) var speed # how fast player walks
var velocity = Vector2() # walking velocity
export (Vector2) var screensize = Vector2() # screensize

var paused = false # stops the player from getting inputs

var is_attacking = false # bool for determing if currently attacking
var can_attack = true # the player can attack

var can_place_wall = true # player can player wall
var wall_destroyed = false # bool if the players wall has recently been destroyed
var wall # instance of the wall

export (int) var snowball_count = 10 # how many snowballs we have
export (int) var max_snowball_count = 10 # how many snowballs we can have

var mouse_position = Vector2(0, 0) # mouse position vector2 local
var global_mouse_position = Vector2(0, 0) # mouse position vector2 global

func _ready():
	screensize = get_viewport_rect().size # set the screensize
	get_node("Sprite/AnimationPlayer").current_animation = "idle" # go to idle anim

func _process(delta):
	get_parent().get_node("HUD").check_snowball("Player", snowball_count) # updating hud stuff
	get_parent().get_node("HUD").check_wall("Player", can_place_wall) # hud stuff
	get_parent().get_node("HUD").check_lives("Player", lives) # hud stuff
	mouse_position = get_local_mouse_position() # local mouse position
	global_mouse_position = get_global_mouse_position() # global mouse position
	if velocity.y == 0: # if player is standing still
		get_node("WalkingSound").stop() # stop the walking sound
		get_node("Sprite/AnimationPlayer").current_animation = "idle" # play idle anim
	else: # if player is starting to move 
		play_walking_sound() # then call walking_sound
	if paused == false: # if we can get inputs
		get_input() # get inputs
	if paused == true: # elsewise
		velocity = Vector2(0,0) # completely stop the player
	position.y = clamp(position.y, screensize.y * .1, screensize.y * .9) # clamp the player
	position += velocity * delta * speed # move his position

func play_walking_sound():
	if get_node("WalkingSound").playing == false:
		get_node("WalkingSound").playing = true

func get_input():
	velocity = Vector2() # reset the velocity
	if Input.is_action_pressed("ui_up"): # up 
		velocity.y -= 1 # go up
		get_node("Sprite/AnimationPlayer").current_animation = "walking_up" # anim for up
	if Input.is_action_pressed("ui_down"): # down
		velocity.y += 1 # go down
		get_node("Sprite/AnimationPlayer").current_animation = "walking_down" # anim for down
	if Input.is_action_pressed("left_mouse_button") and can_attack and snowball_count > 0: # if the player can attack
		is_attacking = true # player is attacking
		player_attack() # attack function
	if Input.is_action_just_released("left_mouse_button"): # releasing of the mouse button 
		is_attacking = false # no longer attacking
	if Input.is_mouse_button_pressed(2) and can_place_wall: # if the player can place wall
		player_place_wall() # place wall

func player_attack(): # ATTACKING FUNCTION
	get_node("ThrowingSound").play()
	var s = Snowball.instance() # spawn in a SNOWBALL
	s.is_player_snowball = true # set the snowball to the player
	s.start(position, mouse_position, "player") # start start the ball at the player, moving towards the mouse
	get_parent().add_child(s) # add it as a child
	can_attack = false # don't let the player attack again
	get_node("AttackTimer").start() # start the player attack timer
	snowball_count -= 1 # decrement the snowball count

func player_place_wall():
	get_node("WallPlacingSound").play()
	wall = Snowwall.instance() # spawn in a SNOWWALL
	wall_destroyed = false # wall is not destroyed
	wall.is_player_wall = true # set the snowwall as a player's snowwall
	wall.start(Vector2(position.x + 75, position.y), false) # place the wall at the players global mouse position
	get_parent().add_child(wall) # add the wall as a child of the tree
	can_place_wall = false # don't let the player place another wall immediatley
	get_node("WallPlaceTimer").start() # start the timer that will let you place another wall
	get_node("WallDestroyTimer").start() # set wall self destruction timer

func add_snow():
	if is_attacking == false: # if player isnt holding down mouse button
		if snowball_count < max_snowball_count: # if we dont have maxxed out snowballs
			snowball_count += 1 # add a snowball

func play_hurt_noise(hurt_noise):
	if hurt_noise == 0:
		get_node("HurtSound").stream = PlayerHit1
		get_node("HurtSound").playing = true
	if hurt_noise == 1:
		get_node("HurtSound").stream = PlayerHit2
		get_node("HurtSound").playing = true
	if hurt_noise == 2:
		get_node("HurtSound").stream = PlayerHit3
		get_node("HurtSound").playing = true

func _on_Player_area_entered(area): # whenever the player enters...
	if area.is_in_group("snowball") and area.is_player_snowball == false and area.snowball_can_hurt: # if its a snowball from enemy
		play_hurt_noise(randi() % 3)
		lives -= 1 # decrement lives
	if lives <= 0: # if at 0 life
		get_parent().char_die("player") # call die in main

func _on_AttackTimer_timeout(): # timer for controlling fire rate
	can_attack = true # can attack again

func _on_WallPlaceTimer_timeout(): # timer for controlling wall placement rate
	can_place_wall = true # can place again

func _on_WallDestroyTimer_timeout(): # when the wall timer is up
	if wall_destroyed == false: # if wall is still up
		if wall.is_player_wall == true: # if its a player wall
			wall.queue_free() # destroy the wall
	else:
		pass
