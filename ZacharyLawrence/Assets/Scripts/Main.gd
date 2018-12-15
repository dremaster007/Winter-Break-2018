extends Node

####### 1) move some code around, move attacking to their respective scenes/scipts
####### 2) players areas (snowpile) to refill snow
####### 3) create an ai that follows rules of the game
#######    tracks players movements, knows where they are, and how
#######    how to react
####### 4) HUD creation
# 5) Main menu/Death menu
# 6) pollish, particles, animations, finished sprites

var wall # initialize the wall

export (PackedScene) var Snowball # Packed Scene of snowball

onready var player = get_node("Player") # lets us type player. instead of get_node
onready var enemy = get_node("Enemy") # lets us type enemy. instead of get_node

onready var player_start_pos = get_node("PlayerStartPosition")  # ez access to player start position
onready var enemy_start_pos = get_node("EnemyStartPosition") # ez access to enemies start position

func _ready():
	get_node("MainThemeBGM").playing = true # start the jams
	new_game() # call new game()

func _process(delta):
	pass

func new_game():
	player.paused = false # no longer paused if previously true
	player.snowball_count = 10 # reset snowball count
	player.position = player_start_pos.position # make the player spawn at his position
	player.lives = 3 # reset lives count
	enemy.set_process(true) # reset the process of enemy
	enemy.enemy_snowball_count = 10 # reset snowball count
	enemy.enemy_lives = 3 # reset lives
	enemy.position = enemy_start_pos.position # make the enemy spawn at their location
	get_node("Enemy/DirectionSwapTimer").start() # start timer for ai direction swapping
	get_node("Enemy/HighSnowAttackTimer").start() # start the enemys timer at the correct time

func char_die(character): # whenever a character dies
	get_node("DeathTimer").start() # start the death timer
	player.paused = true # players inputs will no longer be recognized
	enemy.set_process(false) # disable the enemys process
	if enemy.enemy_state == "high_snow": # if enemy is in high snow
		get_node("Enemy/HighSnowAttackTimer").stop() # stop that timer
	elif enemy.enemy_state == "low_snow": # in low snow
		get_node("Enemy/LowSnowAttackTimer").stop() # stop that timer as well
	if character == "player": # if the character that died is the player
		print ("the player has died") # do stuff respectively
	elif character == "enemy": # otherwise
		print ("the enemy has died") # do stuff for enemy

func _on_DeathTimer_timeout(): # timer for in between game and starting a new one
	new_game() # calling new game
