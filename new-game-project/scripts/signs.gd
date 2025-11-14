extends Area2D

@export var dialogue_text: String = "Welcome to Equalia! Learning awaits."
var player_in_range: bool = false

@onready var interact_label = $InteractLabel if has_node("InteractLabel") else null

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		if interact_label:
			interact_label.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		if interact_label:
			interact_label.visible = false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		get_tree().root.get_node("Game").start_cinematic(dialogue_text)
