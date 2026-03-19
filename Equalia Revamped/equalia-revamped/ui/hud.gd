extends CanvasLayer

# Notice we use % here now!
@onready var plank_label = %PlankLabel

func _process(_delta):
	# If it still stays at 0 after this, Godot will actually throw an 
	# error telling us exactly what is wrong, but this should fix it!
	if plank_label:
		plank_label.text = "x " + str(GlobalData.inventory_quarter_planks)
