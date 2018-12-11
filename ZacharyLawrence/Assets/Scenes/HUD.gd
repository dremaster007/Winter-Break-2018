extends Node

onready var player = get_parent().get_node("Player")
onready var enemy = get_parent().get_node("Enemy")

func check_lives(character, lives):
	if lives == 0:
		get_node("%s/Health/Health1" % character).hide()
		get_node("%s/Health/Health2" % character).hide()
		get_node("%s/Health/Health3" % character).hide()
	elif lives == 1:
		get_node("%s/Health/Health1" % character).show()
		get_node("%s/Health/Health2" % character).hide()
		get_node("%s/Health/Health3" % character).hide()
	elif lives == 2:
		get_node("%s/Health/Health1" % character).show()
		get_node("%s/Health/Health2" % character).show()
		get_node("%s/Health/Health3" % character).hide()
	elif lives == 3:
		get_node("%s/Health/Health1" % character).show()
		get_node("%s/Health/Health2" % character).show()
		get_node("%s/Health/Health3" % character).show()

func check_snowball(character, snowball_count):
	if snowball_count == 0:
		get_node("%s/Snowballs/Snowball1" % character).hide()
		get_node("%s/Snowballs/Snowball2" % character).hide()
		get_node("%s/Snowballs/Snowball3" % character).hide()
		get_node("%s/Snowballs/Snowball4" % character).hide()
		get_node("%s/Snowballs/Snowball5" % character).hide()
		get_node("%s/Snowballs/Snowball6" % character).hide()
		get_node("%s/Snowballs/Snowball7" % character).hide()
		get_node("%s/Snowballs/Snowball8" % character).hide()
		get_node("%s/Snowballs/Snowball9" % character).hide()
		get_node("%s/Snowballs/Snowball10" % character).hide()
	if snowball_count == 1:
		get_node("%s/Snowballs/Snowball1" % character).show()
		get_node("%s/Snowballs/Snowball2" % character).hide()
		get_node("%s/Snowballs/Snowball3" % character).hide()
		get_node("%s/Snowballs/Snowball4" % character).hide()
		get_node("%s/Snowballs/Snowball5" % character).hide()
		get_node("%s/Snowballs/Snowball6" % character).hide()
		get_node("%s/Snowballs/Snowball7" % character).hide()
		get_node("%s/Snowballs/Snowball8" % character).hide()
		get_node("%s/Snowballs/Snowball9" % character).hide()
		get_node("%s/Snowballs/Snowball10" % character).hide()
	if snowball_count == 2:
		get_node("%s/Snowballs/Snowball1" % character).show()
		get_node("%s/Snowballs/Snowball2" % character).show()
		get_node("%s/Snowballs/Snowball3" % character).hide()
		get_node("%s/Snowballs/Snowball4" % character).hide()
		get_node("%s/Snowballs/Snowball5" % character).hide()
		get_node("%s/Snowballs/Snowball6" % character).hide()
		get_node("%s/Snowballs/Snowball7" % character).hide()
		get_node("%s/Snowballs/Snowball8" % character).hide()
		get_node("%s/Snowballs/Snowball9" % character).hide()
		get_node("%s/Snowballs/Snowball10" % character).hide()
	if snowball_count == 3:
		get_node("%s/Snowballs/Snowball1" % character).show()
		get_node("%s/Snowballs/Snowball2" % character).show()
		get_node("%s/Snowballs/Snowball3" % character).show()
		get_node("%s/Snowballs/Snowball4" % character).hide()
		get_node("%s/Snowballs/Snowball5" % character).hide()
		get_node("%s/Snowballs/Snowball6" % character).hide()
		get_node("%s/Snowballs/Snowball7" % character).hide()
		get_node("%s/Snowballs/Snowball8" % character).hide()
		get_node("%s/Snowballs/Snowball9" % character).hide()
		get_node("%s/Snowballs/Snowball10" % character).hide()
	if snowball_count == 4:
		get_node("%s/Snowballs/Snowball1" % character).show()
		get_node("%s/Snowballs/Snowball2" % character).show()
		get_node("%s/Snowballs/Snowball3" % character).show()
		get_node("%s/Snowballs/Snowball4" % character).show()
		get_node("%s/Snowballs/Snowball5" % character).hide()
		get_node("%s/Snowballs/Snowball6" % character).hide()
		get_node("%s/Snowballs/Snowball7" % character).hide()
		get_node("%s/Snowballs/Snowball8" % character).hide()
		get_node("%s/Snowballs/Snowball9" % character).hide()
		get_node("%s/Snowballs/Snowball10" % character).hide()
	if snowball_count == 5:
		get_node("%s/Snowballs/Snowball1" % character).show()
		get_node("%s/Snowballs/Snowball2" % character).show()
		get_node("%s/Snowballs/Snowball3" % character).show()
		get_node("%s/Snowballs/Snowball4" % character).show()
		get_node("%s/Snowballs/Snowball5" % character).show()
		get_node("%s/Snowballs/Snowball6" % character).hide()
		get_node("%s/Snowballs/Snowball7" % character).hide()
		get_node("%s/Snowballs/Snowball8" % character).hide()
		get_node("%s/Snowballs/Snowball9" % character).hide()
		get_node("%s/Snowballs/Snowball10" % character).hide()
	if snowball_count == 6:
		get_node("%s/Snowballs/Snowball1" % character).show()
		get_node("%s/Snowballs/Snowball2" % character).show()
		get_node("%s/Snowballs/Snowball3" % character).show()
		get_node("%s/Snowballs/Snowball4" % character).show()
		get_node("%s/Snowballs/Snowball5" % character).show()
		get_node("%s/Snowballs/Snowball6" % character).show()
		get_node("%s/Snowballs/Snowball7" % character).hide()
		get_node("%s/Snowballs/Snowball8" % character).hide()
		get_node("%s/Snowballs/Snowball9" % character).hide()
		get_node("%s/Snowballs/Snowball10" % character).hide()
	if snowball_count == 7:
		get_node("%s/Snowballs/Snowball1" % character).show()
		get_node("%s/Snowballs/Snowball2" % character).show()
		get_node("%s/Snowballs/Snowball3" % character).show()
		get_node("%s/Snowballs/Snowball4" % character).show()
		get_node("%s/Snowballs/Snowball5" % character).show()
		get_node("%s/Snowballs/Snowball6" % character).show()
		get_node("%s/Snowballs/Snowball7" % character).show()
		get_node("%s/Snowballs/Snowball8" % character).hide()
		get_node("%s/Snowballs/Snowball9" % character).hide()
		get_node("%s/Snowballs/Snowball10" % character).hide()
	if snowball_count == 8:
		get_node("%s/Snowballs/Snowball1" % character).show()
		get_node("%s/Snowballs/Snowball2" % character).show()
		get_node("%s/Snowballs/Snowball3" % character).show()
		get_node("%s/Snowballs/Snowball4" % character).show()
		get_node("%s/Snowballs/Snowball5" % character).show()
		get_node("%s/Snowballs/Snowball6" % character).show()
		get_node("%s/Snowballs/Snowball7" % character).show()
		get_node("%s/Snowballs/Snowball8" % character).show()
		get_node("%s/Snowballs/Snowball9" % character).hide()
		get_node("%s/Snowballs/Snowball10" % character).hide()
	if snowball_count == 9:
		get_node("%s/Snowballs/Snowball1" % character).show()
		get_node("%s/Snowballs/Snowball2" % character).show()
		get_node("%s/Snowballs/Snowball3" % character).show()
		get_node("%s/Snowballs/Snowball4" % character).show()
		get_node("%s/Snowballs/Snowball5" % character).show()
		get_node("%s/Snowballs/Snowball6" % character).show()
		get_node("%s/Snowballs/Snowball7" % character).show()
		get_node("%s/Snowballs/Snowball8" % character).show()
		get_node("%s/Snowballs/Snowball9" % character).show()
		get_node("%s/Snowballs/Snowball10" % character).hide()
	if snowball_count == 10:
		get_node("%s/Snowballs/Snowball1" % character).show()
		get_node("%s/Snowballs/Snowball2" % character).show()
		get_node("%s/Snowballs/Snowball3" % character).show()
		get_node("%s/Snowballs/Snowball4" % character).show()
		get_node("%s/Snowballs/Snowball5" % character).show()
		get_node("%s/Snowballs/Snowball6" % character).show()
		get_node("%s/Snowballs/Snowball7" % character).show()
		get_node("%s/Snowballs/Snowball8" % character).show()
		get_node("%s/Snowballs/Snowball9" % character).show()
		get_node("%s/Snowballs/Snowball10" % character).show()

func check_wall(character, can_place_wall):
	if can_place_wall:
		get_node("%s/Walls/Wall1" % character).show()
	elif can_place_wall == false:
		get_node("%s/Walls/Wall1" % character).hide()