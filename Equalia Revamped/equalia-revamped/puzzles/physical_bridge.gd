extends Node2D

@onready var broken_sprite = $BrokenSprite
@onready var solid_bridge = $SolidBridge

func _ready():
	# When the level starts, make sure it is broken
	broken_sprite.visible = true
	solid_bridge.visible = false
	solid_bridge.process_mode = Node.PROCESS_MODE_DISABLED

# The Sign will call this function when the puzzle is solved!
func fix_bridge():
	print("Bridge: I am fixing myself!")
	broken_sprite.visible = false
	solid_bridge.visible = true
	solid_bridge.process_mode = Node.PROCESS_MODE_INHERIT
