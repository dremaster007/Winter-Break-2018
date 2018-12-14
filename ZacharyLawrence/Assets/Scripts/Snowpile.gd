extends Area2D

var player_is_in_snowpile = false # tells whether or not we are in the snowpile
var player_can_add_snowball = true # allows you to add more snowballs on timeout

var enemy_is_in_snowpile = false # tells whether or not we are in the snowpile
var enemy_can_add_snowball = true # allows you to add more snowballs on timeout

func _process(delta):
	if player_is_in_snowpile:
		if player_can_add_snowball: # if we can add a snowball....
			player_can_add_snowball = false # now we can't
			get_node("PlayerSnowAddTimer").start() # start the timer that will add snow
	if enemy_is_in_snowpile:
		if enemy_can_add_snowball: # if enemy can add a snowball....
			enemy_can_add_snowball = false # now enemy can't
			get_node("EnemySnowAddTimer").start() # start the enemy timer that will add snow to enemy

func _on_Snowpile_area_entered(area):
	if area.is_in_group("player"):
		player_is_in_snowpile = true
	if area.is_in_group("enemy"):
		enemy_is_in_snowpile = true

func _on_Snowpile_area_exited(area): # if you leave the area,
	if area.is_in_group("player"):
		player_is_in_snowpile = false
		get_node("PlayerSnowAddTimer").stop() # stop the timer that will add snow
		player_can_add_snowball = true # but allow you to reenter the snowpile
	if area.is_in_group("enemy"):
		enemy_is_in_snowpile = false
		get_node("EnemySnowAddTimer").stop() # stop the timer that will add snow
		enemy_can_add_snowball = true # but allow you to reenter the snowpile

func _on_PlayerSnowAddTimer_timeout(): # when the timer completes
	get_parent().get_node("Player").add_snow() # add snow (in the player script)
	player_can_add_snowball = true # allows you to add more snow again

func _on_EnemySnowAddTimer_timeout():
	get_parent().get_node("Enemy").add_snow() # add snow (in the player script)
	enemy_can_add_snowball = true # allows you to add more snow again
