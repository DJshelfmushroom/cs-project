extends Node3D

var puzzles = [preload("res://scenes/puzzles/puzzle_one_3d.tscn"), preload("res://scenes/puzzles/puzzle_two_3d.tscn"), preload("res://scenes/puzzles/simon_puzzle_3d.tscn"),
preload("res://scenes/puzzles/reflex_puzzle_3d.tscn"), preload("res://scenes/puzzles/numerle_puzzle_3d.tscn"), preload("res://scenes/puzzles/segment_puzzle_3d.tscn"), 
preload("res://scenes/puzzles/disable_puzzle_3d.tscn"), preload("res://scenes/puzzles/colors_puzzle_3d.tscn"), preload("res://scenes/puzzles/switches_puzzle_3d.tscn"),
preload("res://scenes/puzzles/yes_no_puzzle_3d.tscn")]

var puzzle_scales = [0.45,0.4,0.5,0.5,0.4,0.4,0.2,0.6,0.08,0.17]

var possible_positions = [
	Vector3(0.5,0.25,0.5),Vector3(0.5,0.25,-0.5),Vector3(0.5,-0.25,0.5),Vector3(0.5,-0.25,-0.5),
	Vector3(-0.5,0.25,0.5),Vector3(-0.5,0.25,-0.5),Vector3(-0.5,-0.25,0.5),Vector3(-0.5,-0.25,-0.5),
	Vector3(0.25,-0.5,0.5),Vector3(0.25,-0.5,-0.5),Vector3(-0.25,-0.5,0.5),Vector3(-0.25,-0.5,-0.5),
	Vector3(0.25,0.5,0.5),Vector3(0.25,0.5,-0.5),Vector3(-0.25,0.5,0.5),Vector3(-0.25,0.5,-0.5),
	Vector3(0.0,0.25,1.0),Vector3(0.0,-0.25,1.0),
	Vector3(0.0,0.25,-1.0),Vector3(0.0,-0.25,-1.0)
]
	
var rotations = [
	Vector3(0.0, 90.0 / 180 * PI, 0.0), Vector3(0.0, -90.0 / 180 * PI, 0.0),
	Vector3(90.0 / 180 * PI, 90.0 / 180 * PI, 0), Vector3(-90.0 / 180 * PI, 90.0 / 180 * PI, 0.0),
	Vector3(0.0, 0.0, 0.0), Vector3(0.0, 180.0 / 180 * PI, 0.0)
]

var strikes
var failed = false
var allcompleted = false
var fix = false
var disable_first = false

var current_puzzles = []


func _ready() -> void:
	for c in $bomb_instance/Games.get_children():
		c.visible = false
	for p in range(puzzles.size()):
		var rand
		var unique = false
		while !unique:
			unique = true
			rand = randi_range(0,possible_positions.size() - 1)
			for puzzle in current_puzzles:
				if puzzle.position == possible_positions[rand]:
					unique = false
		var puzzle_inst = puzzles[p].instantiate()
		puzzle_inst.position = possible_positions[rand]
		puzzle_inst.scale = Vector3(puzzle_scales[p],puzzle_scales[p],puzzle_scales[p])
		if rand < 4:
			puzzle_inst.rotation = rotations[0]
		elif rand < 8:
			puzzle_inst.rotation = rotations[1]
		elif rand < 12:
			puzzle_inst.rotation = rotations[2]
		elif rand < 16:
			puzzle_inst.rotation = rotations[3]
		elif rand < 18:
			puzzle_inst.rotation = rotations[4]
		else:
			puzzle_inst.rotation = rotations[5]
		$bomb_instance/Games.add_child(puzzle_inst)
		current_puzzles.append(puzzle_inst)
		
	strikes = 0

func _process(_delta: float) -> void:
	if (fix == false):
		if (puzzles_completed() && !failed):
			$TimerNode.stop_timer()
			$TimerNode/Timer/TimeLabel.add_theme_color_override("font_color", "green")
			$StrikesLabel.add_theme_color_override("font_color", "green")
			allcompleted = true
			$RedWireButton.visible = true
	else:
		fix = false
		
	if (strikes >= 3 || ($TimerNode/Timer.time_left <= 0 && !allcompleted)):
		$StrikesLabel.add_theme_color_override("font_color", "red")
		$TimerNode/Timer/TimeLabel.add_theme_color_override("font_color", "red")
		failed = true
		$GameOverLabel.visible = true
		$ReturnButton.visible = true
		$Camera3D/roltateaxis2.hide()
	for p in current_puzzles:
		if p.id == 7:
			if p.completed:
				disable_first = true
			if (disable_consequence()) && !disable_first:
				strikes = 3
				failed = true
			break

func puzzles_completed():
	var completed = true
	for p in current_puzzles:
		if !p.completed:
			completed = false
	if completed:
		return true
	else:
		return false


func disable_consequence():
	for c in current_puzzles:
		if c.completed && c.id != 7:
			return true
	return false



func _on_back_button_up() -> void:
	if (allcompleted):
		SaveManager.pack1owned += 1
		SaveManager.totalxp += 30
	else:
		SaveManager.totalxp += 10
	SaveManager.save()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
