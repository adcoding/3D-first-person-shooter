extends Node

func _on_Back_pressed():
	if get_tree().change_scene("res://MainMenu.tscn") !=OK:
		print("An unexpected error occured when trying to switch to the Readme scene")