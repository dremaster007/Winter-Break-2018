extends Area2D

onready var player = get_parent().get_node("Player")
onready var enemy = get_parent().get_node("Enemy")

export (bool) var is_player_wall = true

func start(target, wall_flipped):
	position = target
	get_node("Sprite").flip_h = wall_flipped

func _on_SnowWall_area_entered(area):
	if area.is_in_group("snowball"): # if the area is a snowball
		if area.is_player_snowball == false and is_player_wall == true and area.snowball_can_hurt: # if the snowball is not the player's and the wall is...
			area.emit_particles()
			if area.destroy_snowball:
				area.queue_free() # destroy the snowball
			player.wall_destroyed = true
			queue_free() # destroy the wall
		elif area.is_player_snowball == true and is_player_wall == false and area.snowball_can_hurt: # otherwise if the snowball is the players and the wall isn't...
			area.emit_particles()
			if area.destroy_snowball:
				area.queue_free() # destroy the snowball
			enemy.enemy_wall_destroyed = true
			queue_free() # destroy the wall
	else:
		pass
