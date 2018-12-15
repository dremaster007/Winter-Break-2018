extends Area2D

onready var player = get_parent().get_node("Player") # ease of access
onready var enemy = get_parent().get_node("Enemy") # ease of access

export (bool) var is_player_wall = true # is this wall the players

func start(target, wall_flipped): # start, with where and if its flipped or not
	position = target # set position
	get_node("Sprite").flip_h = wall_flipped # set the flip

func _on_SnowWall_area_entered(area): # if the snowall enters an area
	if area.is_in_group("snowball"): # if the area is a snowball
		if area.is_player_snowball == false and is_player_wall == true and area.snowball_can_hurt: # if the snowball is not the player's and the wall is...
			area.emit_particles() # emit the particles of the snowball
			if area.destroy_snowball: # if we can destroy snowball
				area.queue_free() # destroy the snowball
			player.wall_destroyed = true # the wall is now desrtoyed (player)
			queue_free() # destroy the wall
		elif area.is_player_snowball == true and is_player_wall == false and area.snowball_can_hurt: # otherwise if the snowball is the players and the wall isn't...
			area.emit_particles() # emit the particles of the snowball
			if area.destroy_snowball: # if we can destroy the snowball
				area.queue_free() # destroy the snowball
			enemy.enemy_wall_destroyed = true # the wall is now destroyed (enemy)
			queue_free() # destroy the wall
	else: # otherwise
		pass # nothing
