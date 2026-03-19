extends Area2D

func _ready():
	# Listen for when the player touches the plank
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Did the player touch it?
	if body.name == "Player":
		# Add 1 to our Global Backpack!
		GlobalData.inventory_quarter_planks += 1
		print("Picked up a 1/4 Plank! Total: ", GlobalData.inventory_quarter_planks)
		
		# Delete the item from the world so they can't pick it up twice
		queue_free()
