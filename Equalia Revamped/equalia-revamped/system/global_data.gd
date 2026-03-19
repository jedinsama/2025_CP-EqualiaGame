extends Node

# --- INVENTORY ---
var inventory_quarter_planks: int = 0
var inventory_half_planks: int = 0

# --- SAVE DATA SYSTEM ---
# "user://" tells Godot to save to the computer's safe app data folder
const SAVE_PATH = "user://equalia_save.json"

# Variables to remember where to spawn the player after loading
var spawn_x: float = 0.0
var spawn_y: float = 0.0
var should_load_position: bool = false

func save_game():
	print("GlobalData: Attempting to save...")
	var save_dict = {
		"quarter_planks": inventory_quarter_planks,
		"half_planks": inventory_half_planks,
		"current_scene": get_tree().current_scene.scene_file_path
	}
	
	# Find the player to get their exact position
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		var player = players[0]
		save_dict["player_x"] = player.global_position.x
		save_dict["player_y"] = player.global_position.y
	else:
		print("WARNING: Could not find Player to save position!")
		return

	# Write the data to a file!
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_dict))
	print("SUCCESS: Game Saved! ", save_dict)

func load_game():
	print("GlobalData: Attempting to load...")
	if not FileAccess.file_exists(SAVE_PATH):
		print("ERROR: No save file found!")
		return
		
	# Read the file
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	if data:
		# 1. Restore the backpack
		inventory_quarter_planks = data["quarter_planks"]
		inventory_half_planks = data.get("half_planks", 0) # .get() is safe in case it's missing
		
		# 2. Set the spawn coordinates so the player knows where to go
		spawn_x = data["player_x"]
		spawn_y = data["player_y"]
		should_load_position = true
		
		# 3. Load the correct level
		print("SUCCESS: Data loaded. Teleporting to level...")
		get_tree().change_scene_to_file(data["current_scene"])
		
func reset_data():
	inventory_quarter_planks = 0
	inventory_half_planks = 0
	should_load_position = false
