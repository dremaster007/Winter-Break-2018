extends Area2D

signal game_over

export (PackedScene) var Snowball # export the snowball scene
export (PackedScene) var Snowwall # export the snowwall scene

var lives = 3

export (int) var speed # how fast player walks
var velocity = Vector2() # walking velocity
export (Vector2) var screensize = Vector2() # screensize 

var is_attacking = false
var can_attack = true # the player can attack

var can_place_wall = true # player can player wall
var wall_destroyed = false 
var wall

export (int) var snowball_count = 10
export (int) var max_snowball_count = 10

var mouse_position = Vector2(0, 0)
var global_mouse_position = Vector2(0, 0)

func _ready():
	screensize = get_viewport_rect().size
	get_node("Sprite/AnimationPlayer").current_animation = "idle"

func _process(delta):
	get_parent().get_node("HUD").check_snowball("Player", snowball_count) # updating hud stuff
	get_parent().get_node("HUD").check_wall("Player", can_place_wall) # hud stuff
	get_parent().get_node("HUD").check_lives("Player", lives) # hud stuff
	mouse_position = get_local_mouse_position() # local mouse position
	global_mouse_position = get_global_mouse_position() # global mouse position
	if velocity.y == 0: # if player is standing still
		get_node("Sprite/AnimationPlayer").current_animation = "idle" # play idle anim
	get_input() # get inputs
	position.y = clamp(position.y, screensize.y * .1, screensize.y * .9) # clamp the player
	position += velocity * delta * speed # move his position

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		get_node("Sprite/AnimationPlayer").current_animation = "walking_up"
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		get_node("Sprite/AnimationPlayer").current_animation = "walking_down"
	if Input.is_action_pressed("left_mouse_button") and can_attack and snowball_count > 0: # if the player can attack
		is_attacking = true
		player_attack() # attack
	if Input.is_action_just_released("left_mouse_button"):
		is_attacking = false
	if Input.is_mouse_button_pressed(2) and can_place_wall: # if the player can place wall
		player_place_wall() # place wall

func player_attack():
	var s = Snowball.instance() # spawn in a SNOWBALL
	s.is_player_snowball = true # set the snowball to the player
	s.start(position, mouse_position, "player") # start start the ball at the player, moving towards the mouse
	get_parent().add_child(s) # add it as a child
	can_attack = false # don't let the player attack again
	get_node("AttackTimer").start() # start the player attack timer
	snowball_count -= 1

func player_place_wall():
	wall = Snowwall.instance() # spawn in a SNOWWALL
	wall_destroyed = false
	wall.is_player_wall = true # set the snowwall as a player's snowwall
	wall.start(Vector2(position.x + 75, position.y), false) # place the wall at the players global mouse position
	get_parent().add_child(wall) # add the wall as a child of the tree
	can_place_wall = false # don't let the player place another wall immediatley
	get_node("WallPlaceTimer").start() # start the timer that will let you place another wall
	get_node("WallDestroyTimer").start() # set wall self destruction timer

func add_snow():
	if is_attacking == false:
		if snowball_count < max_snowball_count:
			snowball_count += 1

func die():
	get_parent().get_node("Enemy").player_die()
	get_node("DeathTimer").start()

func _on_Player_area_entered(area):
	if area.is_in_group("snowball") and area.is_player_snowball == false:
		lives -= 1
	if lives <= 0:
		die()

func _on_AttackTimer_timeout():
	can_attack = true

func _on_WallPlaceTimer_timeout():
	can_place_wall = true

func _on_WallDestroyTimer_timeout():
	if wall_destroyed == false:
		if wall.is_player_wall == true:
			wall.queue_free()
	else:
		pass

func _on_DeathTimer_timeout():
	emit_signal("game_over")
