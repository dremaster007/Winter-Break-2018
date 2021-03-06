extends Area2D

export var is_player_wall = true

func start(mousepos):
	position = mousepos
	#position = get_parent().get_node("Player").mouse_position

func _on_SnowWall_area_entered(area):
	if area.is_in_group("snowball"): # if the area is a snowball
		if area.is_player_snowball == false and is_player_wall == true: # if the snowball is not the player's and the wall is...
			area.queue_free() # destroy the snowball
			queue_free() # destroy the wall
		elif area.is_player_snowball == true and is_player_wall == false: # otherwise if the snowball is the players and the wall isn't...
			area.queue_free() # destroy the snowball
			queue_free() # destroy the wall
	else:
		pass
