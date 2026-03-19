extends Node2D

@onready var solid_door = $SolidDoor

# We changed the name here so the Scale Trigger knows how to call it!
func fix_bridge():
	print("Door: Opening!")
	# Hide the door and turn off its collision so the player can walk past!
	solid_door.visible = false
	solid_door.process_mode = Node.PROCESS_MODE_DISABLED
