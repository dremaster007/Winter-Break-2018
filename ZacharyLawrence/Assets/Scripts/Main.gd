extends Node

var can_attack = true

export (PackedScene) var Snowball

onready var player = get_node("Player")
onready var enemy = get_node("Enemy")

onready var player_start_pos = get_node("PlayerStartPosition")
onready var enemy_start_pos = get_node("EnemyStartPosition")

func _ready():
	player.position = player_start_pos.position
	enemy.position = enemy_start_pos.position


func _physics_process(delta):
	if Input.is_mouse_button_pressed(1) and can_attack:
		attack()

func attack():
	var s = Snowball.instance()
	s.start(player.position, player.mouse_position.y)
	add_child(s)
	#s.position = player.position
	#s.velocity.x = player.mouse_position.x
	#s.velocity.y = player.mouse_position.y
	can_attack = false
	get_node("AttackTimer").start()

func _on_AttackTimer_timeout():
	can_attack = true