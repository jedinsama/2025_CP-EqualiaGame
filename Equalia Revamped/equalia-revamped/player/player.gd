extends CharacterBody2D

# --- MOVEMENT SETTINGS ---
const SPEED = 150.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
func _ready():
	# If we just loaded a game, teleport to the saved spot!
	if GlobalData.should_load_position:
		global_position = Vector2(GlobalData.spawn_x, GlobalData.spawn_y)
		GlobalData.should_load_position = false # Reset it so we don't teleport every time we die
		

func _physics_process(delta):
	# === TEMPORARY SAVE/LOAD TEST KEYS ===
	if Input.is_key_pressed(KEY_K):
		GlobalData.save_game()
	elif Input.is_key_pressed(KEY_L):
		GlobalData.load_game()
		
	# 1. ADD GRAVITY
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. HANDLE JUMP
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. GET INPUT DIRECTION (-1 for left, 1 for right, 0 for still)
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# 4. APPLY MOVEMENT
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 5. FLIP SPRITE based on direction
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# === 6. HANDLE ANIMATIONS (The New Magic!) ===
	# If we are in the air, we are jumping/falling
	if not is_on_floor():
		animated_sprite.play("jump")
	# If we are on the floor AND pressing a direction key, we are running
	elif direction != 0:
		animated_sprite.play("run")
	# If we are on the floor and NOT pressing a key, we are idle
	else:
		animated_sprite.play("idle")

	# 7. MOVE THE PLAYER
	move_and_slide()
