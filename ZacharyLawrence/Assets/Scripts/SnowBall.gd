extends Area2D

var move_enemy # 0 = move down, 1 = move up
var velocity = Vector2(0, 0) # We set this velocity in the main script

export (int) var speed # speed of the snowball

var is_player_snowball = true # is a player snowball
var snowball_can_hurt = true

var destroy_snowball = false

func start(pos, target, character): # called when snowball is instanced
	position = pos # set the position of snowball
	get_node("Sprite").frame = randi() % 3 # get a random sprite for snowball
	if character == "player": # if player is throwing it
		is_player_snowball = true # is a player snowball
		velocity = Vector2(target) # velocity is set towards the target
	elif character == "enemy": # if a enemy
		is_player_snowball = false # not a player snowball
		velocity = Vector2(target) # velocity is set towards the target
	if velocity > Vector2(0,0) or velocity < Vector2(0,0): # if the snowball is moving
		velocity = velocity.normalized() * speed # normalize it and multiply by speed

func _process(delta):
	position += velocity * delta # move its position
	if is_player_snowball: # if the player threw the snowball
		if position.x > get_parent().get_node("Player").screensize.x * .95: # if the position is near end of screen
			emit_particles()
			if destroy_snowball:
				queue_free() # queue free the snowball
	elif is_player_snowball == false: # if enemy threw it
		if position.x < get_parent().get_node("Player").screensize.x * .05: # if position is just past player
			emit_particles()
			if destroy_snowball:
				queue_free() # queue free the snowball

func emit_particles():
	velocity = Vector2(0, 0) # stops the snowball
	get_node("SnowballExplosion").emitting = true # emit particles
	get_node("ParticleTimer").start() # start particle timer
	get_node("Sprite").hide() # hide the sprite
	snowball_can_hurt = false # basically disables the whole snowball

func _on_ParticleTimer_timeout(): # when the timer times out
	destroy_snowball = true # can now fully destroy (queue free) the snowball
