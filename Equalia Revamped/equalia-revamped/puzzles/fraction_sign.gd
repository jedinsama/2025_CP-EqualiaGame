extends Area2D

var player_in_zone = false
var is_fixed = false 

@onready var prompt_label = $PromptLabel

@export var puzzle_ui_scene: PackedScene = preload("res://puzzles/bridge_puzzle_ui.tscn")

# === NEW: This creates a slot in the Inspector to link a specific bridge! ===
@export var linked_bridge: Node2D 

func _ready():
	if prompt_label:
		prompt_label.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta):
	if is_fixed:
		return 
		
	if player_in_zone and Input.is_action_just_pressed("interact"):
		open_puzzle()

func open_puzzle():
	var puzzle_instance = puzzle_ui_scene.instantiate()
	get_tree().current_scene.add_child(puzzle_instance)
	puzzle_instance.puzzle_solved.connect(_on_bridge_fixed)
	get_tree().paused = true

func _on_bridge_fixed():
	is_fixed = true
	
	if prompt_label:
		prompt_label.visible = false
		
	# === NEW: Tell the linked bridge to fix itself! ===
	if linked_bridge != null:
		linked_bridge.fix_bridge()
	else:
		print("WARNING: You forgot to link a bridge to this sign in the Inspector!")

func _on_body_entered(body):
	if body.name == "Player" and not is_fixed:
		player_in_zone = true
		if prompt_label:
			prompt_label.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_zone = false
		if prompt_label:
			prompt_label.visible = false
