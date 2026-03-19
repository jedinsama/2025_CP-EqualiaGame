extends Area2D

# This creates a slot in the Inspector just like the bridge did!
@export var respawn_point: Node2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Did the player fall in?
	if body.name == "Player":
		print("Player fell! Teleporting to safety...")
		
		# Do we have a safe spot linked?
		if respawn_point != null:
			# Move the player instantly to the marker's location
			body.global_position = respawn_point.global_position
			
			# Reset their falling speed so they don't slam into the ground after teleporting
			body.velocity = Vector2.ZERO 
		else:
			print("WARNING: You forgot to link a SafeSpot to this FallZone!")
