extends CanvasLayer

signal puzzle_solved

var current_weight = 0
var target_weight = 5 # 5 quarters = 5/4!

@onready var scale_visual = %ScaleVisual
@onready var title_label = %Title

func _ready():
	scale_visual.max_value = target_weight
	scale_visual.value = 0
	
	%BtnQuarter.pressed.connect(_on_quarter_pressed)
	%BtnReset.pressed.connect(_on_reset_pressed)
	%BtnClose.pressed.connect(_on_close_pressed)

func _on_quarter_pressed():
	if GlobalData.inventory_quarter_planks > 0:
		GlobalData.inventory_quarter_planks -= 1
		current_weight += 1
		scale_visual.value = current_weight
		
		# Educational feedback!
		if current_weight == 4:
			title_label.text = "That's 4/4 (1 Whole). We need MORE power!"
		else:
			title_label.text = "Added 1/4! Current weight: " + str(current_weight) + "/4"
			
		check_win_condition()
	else:
		title_label.text = "You don't have any 1/4 pieces left!"

func check_win_condition():
	if current_weight == target_weight:
		title_label.text = "5/4! An Improper Fraction! The door is opening!"
		await get_tree().create_timer(2.0).timeout
		puzzle_solved.emit()
		get_tree().paused = false
		queue_free()
	elif current_weight > target_weight:
		title_label.text = "Too heavy! Reset and try again."

func _on_reset_pressed():
	GlobalData.inventory_quarter_planks += current_weight
	current_weight = 0
	scale_visual.value = 0
	title_label.text = "We need exactly 5/4 power!"

func _on_close_pressed():
	_on_reset_pressed()
	get_tree().paused = false
	queue_free()
