extends Node

var can_attack = true
var enemy_can_attack = true

var can_place_wall = true

var wall

export (PackedScene) var Snowball
export (PackedScene) var Snowwall

onready var player = get_node("Player")
onready var enemy = get_node("Enemy")

onready var player_start_pos = get_node("PlayerStartPosition")
onready var enemy_start_pos = get_node("EnemyStartPosition")

func _ready():
	get_node("EnemyAttackTimer").start()
	player.position = player_start_pos.position
	enemy.position = enemy_start_pos.position

func _process(delta):
	if Input.is_mouse_button_pressed(1) and can_attack:
		player_attack()
	if Input.is_mouse_button_pressed(2) and can_place_wall:
		player_place_wall()

func player_attack():
	var s = Snowball.instance()
	s.is_player_snowball = true
	s.start(player.position, player.mouse_position.y, "player")
	add_child(s)
	#s.position = player.position
	#s.velocity.x = player.mouse_position.x
	#s.velocity.y = player.mouse_position.y
	can_attack = false
	get_node("AttackTimer").start()

func enemy_attack():
	var es = Snowball.instance()
	es.is_player_snowball = false
	es.start(enemy.position, player.position.y - enemy.position.y, "enemy")
	add_child(es)
	enemy_can_attack = false
	get_node("EnemyAttackTimer").start()

func player_place_wall():
	wall = Snowwall.instance()
	player.is_player_wall = true
	wall.start(player.global_mouse_position)
	add_child(wall)
	can_place_wall = false
	get_node("WallPlaceTimer").start()
	get_node("WallDestroyTimer").start()

func _on_AttackTimer_timeout():
	can_attack = true

func _on_EnemyAttackTimer_timeout():
	enemy_can_attack = true

func _on_AllowsEnemyAttack_timeout():
	enemy_attack()

func _on_WallPlaceTimer_timeout():
	can_place_wall = true

func _on_WallDestroyTimer_timeout():
	if player.wall_destroyed == false or player.is_player_wall == true:
		wall.queue_free()
	else:
		pass