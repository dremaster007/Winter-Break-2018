extends Node

func _on_TextureButton_pressed(): # When you press the penguin / start button
#	get_node("res://Assets/Scenes/Main.tscn").add_child(get_node("MainThemeBGM"))
	get_tree().change_scene("res://Assets/Scenes/Main.tscn") # change the scene

func _ready():
	get_node("MainThemeBGM").playing = true # start the jams
	