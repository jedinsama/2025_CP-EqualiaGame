extends CanvasLayer

# We use 4 as our target because 4/4 = 1 Whole
signal puzzle_solved

var current_bridge_pieces = 0
var target_pieces = 4 

@onready var bridge_visual = $BridgeVisual
@onready var title_label = $Title

func _ready():
	bridge_visual.max_value = target_pieces
	bridge_visual.value = 0
	
	$BtnQuarter.pressed.connect(_on_quarter_pressed)
	$BtnHalf.pressed.connect(_on_half_pressed)
	$BtnReset.pressed.connect(_on_reset_pressed)
	
	# === NEW: Connect the close button ===
	$BtnClose.pressed.connect(_on_close_pressed)
# When they tap 1/4, we add 1 piece (because 1/4 is 1 out of 4)
func _on_quarter_pressed():
	# CHECK THE BACKPACK FIRST!
	if GlobalData.inventory_quarter_planks > 0:
		# 1. Take it out of the backpack
		GlobalData.inventory_quarter_planks -= 1
		# 2. Add it to the bridge
		add_to_bridge(1)
		# 3. Update the text to encourage them
		title_label.text = "Placed a 1/4 Plank! Keep going!"
	else:
		# They don't have any!
		title_label.text = "You don't have any 1/4 Planks in your backpack!"

# When they tap 1/2, we add 2 pieces (because 1/2 is 2/4)
func _on_half_pressed():
	add_to_bridge(2)

func _on_reset_pressed():
	# If they reset, we must give them their pieces back!
	GlobalData.inventory_quarter_planks += current_bridge_pieces  # Refund 1/4 planks (simplifying for now)
	
	current_bridge_pieces = 0
	bridge_visual.value = 0
	title_label.text = "Fix the Bridge! We need exactly 1 Whole."

func _on_close_pressed():
	# 1. First, refund any pieces they already put on the bridge!
	_on_reset_pressed()
	
	# 2. Unpause the game so the player can walk again
	get_tree().paused = false
	
	# 3. Delete the UI pop-up
	queue_free()

func add_to_bridge(amount):
	current_bridge_pieces += amount
	bridge_visual.value = current_bridge_pieces
	
	# Check if they won or went over!
	if current_bridge_pieces == target_pieces:
		title_label.text = "Perfect! 4/4 = 1 Whole!"
		win_puzzle()
	elif current_bridge_pieces > target_pieces:
		title_label.text = "Oh no! Too long! Reset and try again."

func win_puzzle():
	# This is where the signal is actually fired off!
	puzzle_solved.emit() 
	
	await get_tree().create_timer(1.5).timeout
	get_tree().paused = false
	queue_free()
