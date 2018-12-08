extends Node


# 1) move some code around, move attacking to their respective scenes/scipts
# 2) players areas (snowpile) to refill snow
# 3) create an ai that follows rules of the game
#    tracks players movements, knows where they are, and how
#    how to react
# 4) HUD creation
# 5) Main menu/Death menu


var can_attack = true # the player can attack
#var enemy_can_attack = true # the enemy can attack

var can_place_wall = true # player can player wall
var player_is_attacking = false # the player is currently attack

var wall # initialize the wall

export (PackedScene) var Snowball # export the snowball scene
export (PackedScene) var Snowwall # export the snowwall scene

onready var player = get_node("Player") # lets us type player. instead of get_node
onready var enemy = get_node("Enemy") # lets us type enemy. instead of get_node

onready var player_start_pos = get_node("PlayerStartPosition")  # ez access to player start position
onready var enemy_start_pos = get_node("EnemyStartPosition") # ez access to enemies start position

func _ready():
	get_node("MainThemeBGM").playing = true
	new_game()

func new_game():
	get_node("EnemyAttackTimer").start() # start the timer for enemy attacking
	player.position = player_start_pos.position # make the player spawn at his position
	enemy.position = enemy_start_pos.position # make the enemy spawn at their location

func _process(delta):
	if player_is_attacking: # setting player.is_attacking variable
		player.player_throw = true
	elif player_is_attacking == false: # setting player.is_attacking variable to false
		player.player_throw = false
	if Input.is_mouse_button_pressed(1) and can_attack: # if the player can attack
		player_attack() # attack
	if Input.is_mouse_button_pressed(2) and can_place_wall: # if the player can place wall
		player_place_wall() # place wall

func player_attack():
	var s = Snowball.instance() # spawn in a SNOWBALL
	s.is_player_snowball = true # set the snowball to the player
	player_is_attacking = true # say that the player is attacking
	s.start(player.position, player.mouse_position, "player") # start start the ball at the player, moving towards the mouse
	add_child(s) # add it as a child
	can_attack = false # don't let the player attack again
	get_node("AttackTimer").start() # start the player attack timer

func enemy_attack():
	var es = Snowball.instance() # spawn in a SNOWBALL
	es.is_player_snowball = false # set the snowball as not a player
	es.start(enemy.position, player.position - enemy.position, "enemy") # start the snowball at the enemy, moving towards the player
	add_child(es) # add it as a child 
	#enemy_can_attack = false # don't let the enemy attack immediately
	get_node("EnemyAttackTimer").wait_time = rand_range(0.1, 0.2) # randomize when the enemy will shoot
	get_node("EnemyAttackTimer").start() # start the enemy shooting timer

func player_place_wall():
	wall = Snowwall.instance() # spawn in a SNOWWALL
	player.is_player_wall = true # set the snowwall as a player's snowwall
	wall.start(player.global_mouse_position) # place the wall at the players global mouse position
	add_child(wall) # add the wall as a child of the tree
	can_place_wall = false # don't let the player place another wall immediatley
	get_node("WallPlaceTimer").start() # start the timer that will let you place another wall
	get_node("WallDestroyTimer").start() # set wall self destruction timer

func _on_AttackTimer_timeout(): # TIMER allows the player to attack again
	can_attack = true
	player_is_attacking = false

#func _on_EnemyAttackTimer_timeout(): # TIMER allows the enemy to attack again
#	enemy_can_attack = true

func _on_AllowsEnemyAttack_timeout(): # TIMER allows the enemy to attack again
	enemy_attack()

func _on_WallPlaceTimer_timeout(): # TIMER allows the replacement of a wall
	can_place_wall = true

func _on_WallDestroyTimer_timeout(): # TIMER 
	if player.wall_destroyed == false or player.is_player_wall == true:
		wall.queue_free()
	else:
		pass

func _on_Player_game_over():
	new_game()

