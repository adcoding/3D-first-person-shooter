extends Node

func _on_Play_pressed():
	if get_tree().change_scene("res://MainScene.tscn") !=OK:
		print("An unexpected error occured when trying to switch to the Readme scene")

func _on_Credits_pressed():
	if get_tree().change_scene("res://Credits.tscn") !=OK:
		print("An unexpected error occured when trying to switch to the Readme scene")
