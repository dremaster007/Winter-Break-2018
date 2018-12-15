extends Node

func _on_TextureButton_pressed(): # When you press the penguin / start button
	get_tree().change_scene("res://Assets/Scenes/Main.tscn") # change the scene
