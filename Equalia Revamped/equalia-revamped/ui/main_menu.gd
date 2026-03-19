extends Control

func _ready():
	# Connect the buttons
	%BtnNewGame.pressed.connect(_on_new_game_pressed)
	%BtnLoadGame.pressed.connect(_on_load_game_pressed)
	%BtnQuit.pressed.connect(_on_quit_pressed)

func _on_new_game_pressed():
	# 1. Wipe the old save data from memory
	GlobalData.reset_data()
	
	# 2. Load the first level! 
	# (IMPORTANT: Make sure this path matches exactly where your level is saved!)
	get_tree().change_scene_to_file("res://levels/level_test.tscn")

func _on_load_game_pressed():
	# Our GlobalData script already handles the loading and level swapping!
	GlobalData.load_game()

func _on_quit_pressed():
	# Closes the game window
	get_tree().quit()
