extends Area2D

@export var combat_scene: PackedScene = preload("res://scenes/combat.tscn")

@export var SPEED: float = 60.0
var direction: int = 1

@onready var ray_cast_right: RayCast2D = $AnimatedSprite2D/RayCastRight
@onready var ray_cast_left: RayCast2D = $AnimatedSprite2D/RayCastLeft

func _physics_process(delta: float) -> void:
	position.x += SPEED * direction * delta

	if ray_cast_right.is_colliding():
		direction = -1
		$AnimatedSprite2D.flip_h = true
	elif ray_cast_left.is_colliding():
		direction = 1
		$AnimatedSprite2D.flip_h = false


func _on_body_entered(body):
	if body.name == "Player":
		print("Player touched enemy — entering combat!")
		#get_tree().change_scene_to_packed(combat_scene)
