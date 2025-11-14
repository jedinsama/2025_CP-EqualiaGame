extends Node2D

# === Node References ===
@onready var player_sprite = $PlayerSprite
@onready var enemy_sprite = $EnemySprite
@onready var player_hp_label = $PlayerHP
@onready var enemy_hp_label = $EnemyHP
@onready var fight_button = $Panel/Fight
@onready var run_button = $Panel/Run
@onready var label = $Panel/Label
@onready var question_panel = $QuestionPanel
@onready var question_label = $QuestionPanel/QuestionLabel
@onready var answer_input = $QuestionPanel/AnswerInput
@onready var submit_button = $QuestionPanel/SubmitButton
@onready var timer_label = $QuestionPanel/TimerLabel  # optional countdown

# === Combat Variables ===
var player_hp = 3
var enemy_hp = 3
var player_turn = true
var current_question = {}
var timer_time = 40.0 # seconds to answer
var question_timer: Timer
var difficulty_level = 1

# === Ready ===
func _ready():
	label.text = "Enemy Slime Appeared!"
	update_hp_labels()

	fight_button.pressed.connect(_on_fight_pressed)
	run_button.pressed.connect(_on_run_pressed)
	submit_button.pressed.connect(_on_submit_pressed)

	# Timer setup
	question_timer = Timer.new()
	add_child(question_timer)
	question_timer.wait_time = timer_time
	question_timer.timeout.connect(_on_timer_timeout)

	question_panel.visible = false


# === Update HP Labels ===
func update_hp_labels():
	player_hp_label.text = "%d/3" % player_hp
	enemy_hp_label.text = "%d/3" % enemy_hp


# === Player Chooses Attack ===
func _on_fight_pressed():
	if not player_turn:
		return

	label.text = "You attacked!"
	enemy_hp -= 1
	update_hp_labels()

	if enemy_hp <= 0:
		label.text = "Enemy defeated!"
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	else:
		player_turn = false
		await get_tree().create_timer(1.0).timeout
		enemy_attack_turn()


# === Player Chooses Run ===
func _on_run_pressed():
	label.text = "You ran away!"
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")


# === Enemy Attack Sequence ===
func enemy_attack_turn():
	label.text = "Enemy preparing attack..."
	await get_tree().create_timer(1.0).timeout
	show_fraction_question()


# === FRACTION QUESTION ===
func show_fraction_question():
	current_question = generate_fraction_question()
	answer_input.text = ""
	question_panel.visible = true
	label.text = "Answer quickly!"
	question_label.text = current_question["text"]
	if timer_label:
		timer_label.text = str(int(timer_time))
	question_timer.start()


# === FRACTION UTILITIES ===
func gcd(a: int, b: int) -> int:
	while b != 0:
		var t = b
		b = a % b
		a = t
	return abs(a)

func lcm(a: int, b: int) -> int:
	return abs(a * b) / gcd(a, b)

func simplify(num: int, den: int) -> Array:
	var g = gcd(num, den)
	return [int(num / g), int(den / g)]

func add_fractions(a_num: int, a_den: int, b_num: int, b_den: int) -> Array:
	var common_den = lcm(a_den, b_den)
	var result_num = a_num * (common_den / a_den) + b_num * (common_den / b_den)
	return simplify(result_num, common_den)


# === Player Submits Answer ===
func _on_submit_pressed():
	if not question_panel.visible:
		return

	var input_text = answer_input.text.strip_edges()
	if input_text == "":
		return

	var parts = input_text.split("/")
	if parts.size() != 2:
		label.text = "❌ Invalid format! Use a/b"
		return

	var player_num = int(parts[0])
	var player_den = int(parts[1])
	var player_simplified = simplify(player_num, player_den)
	var correct = current_question["answer"]

	question_panel.visible = false
	question_timer.stop()

	if player_simplified[0] == correct[0] and player_simplified[1] == correct[1]:
		label.text = "✅ Correct! Counterattack!"
		enemy_hp -= 1
		update_hp_labels()
		if enemy_hp <= 0:
			label.text = "Enemy defeated!"
			await get_tree().create_timer(1.0).timeout
			get_tree().change_scene_to_file("res://scenes/game.tscn")
		else:
			await get_tree().create_timer(1.0).timeout
			player_turn = true
			label.text = "Your turn!"
	else:
		label.text = "❌ Wrong! You took damage!"
		player_hp -= 1
		update_hp_labels()
		if player_hp <= 0:
			label.text = "You were defeated!"
			await get_tree().create_timer(1.5).timeout
			get_tree().change_scene_to_file("res://scenes/game.tscn")
		else:
			await get_tree().create_timer(1.0).timeout
			player_turn = true
			label.text = "Your turn!"


# === Timer Timeout ===
func _on_timer_timeout():
	if question_panel.visible:
		question_panel.visible = false
		label.text = "⏰ Too slow! You took damage!"
		player_hp -= 1
		update_hp_labels()

		if player_hp <= 0:
			label.text = "You were defeated!"
			await get_tree().create_timer(1.5).timeout
			get_tree().change_scene_to_file("res://scenes/game.tscn")
		else:
			await get_tree().create_timer(1.0).timeout
			player_turn = true
			label.text = "Your turn!"


# === Countdown Display ===
func _process(delta):
	if question_panel.visible and question_timer and question_timer.time_left > 0:
		if timer_label:
			timer_label.text = str(int(ceil(question_timer.time_left)))


# === Fraction Question Generator ===
func generate_fraction_question() -> Dictionary:
	var a = randi_range(1, 8)
	var b = randi_range(a + 1, 9)
	var c = randi_range(1, 8)
	var d = randi_range(c + 1, 9)

	var correct = add_fractions(a, b, c, d)
	var correct_num = correct[0]
	var correct_den = correct[1]

	var diff_hint = ""
	if difficulty_level == 1:
		diff_hint = " (Easy)"
	elif difficulty_level == 2:
		diff_hint = " (Medium)"
	else:
		diff_hint = " (Hard)"

	return {
		"text": "Solve: %d/%d + %d/%d = ?%s" % [a, b, c, d, diff_hint],
		"answer": [correct_num, correct_den]
	}
