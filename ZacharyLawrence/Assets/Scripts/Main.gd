extends Node


####### 1) move some code around, move attacking to their respective scenes/scipts
####### 2) players areas (snowpile) to refill snow
# 3) create an ai that follows rules of the game
#    tracks players movements, knows where they are, and how
#    how to react
# 4) HUD creation
# 5) Main menu/Death menu

var wall # initialize the wall

export (PackedScene) var Snowball

onready var player = get_node("Player") # lets us type player. instead of get_node
onready var enemy = get_node("Enemy") # lets us type enemy. instead of get_node

onready var player_start_pos = get_node("PlayerStartPosition")  # ez access to player start position
onready var enemy_start_pos = get_node("EnemyStartPosition") # ez access to enemies start position

func _ready():
	get_node("MainThemeBGM").playing = true
	new_game()

func new_game():
	#get_node("Enemy/EnemyAttackTimer").start() # start the timer for enemy attacking
	player.position = player_start_pos.position # make the player spawn at his position
	enemy.position = enemy_start_pos.position # make the enemy spawn at their location

func _process(delta):
	pass

func _on_Player_game_over():
	new_game()

