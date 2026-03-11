extends Node3D

var puzzles = [preload("res://scenes/puzzles/puzzle_one_3d.tscn"), preload("res://scenes/puzzles/puzzle_two_3d.tscn"), preload("res://scenes/puzzles/simon_puzzle_3d.tscn"),
preload("res://scenes/puzzles/reflex_puzzle_3d.tscn"), preload("res://scenes/puzzles/numerle_puzzle_3d.tscn"), preload("res://scenes/puzzles/segment_puzzle_3d.tscn"), 
preload("res://scenes/puzzles/disable_puzzle_3d.tscn"), preload("res://scenes/puzzles/colors_puzzle_3d.tscn"), preload("res://scenes/puzzles/switches_puzzle_3d.tscn"),
preload("res://scenes/puzzles/yes_no_puzzle_3d.tscn"), preload("res://scenes/puzzles/target_puzzle_3d.tscn"), preload("res://scenes/puzzles/track_puzzle_3d.tscn")]

var puzzle_scales = [0.45,0.4,0.5,0.5,0.4,0.35,0.2,0.6,0.08,0.17,0.2,0.2]

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

var puzzles_on_front = 0

var strikes
var failed = false
var allcompleted = false
var fix = false
var disable_first = false

var current_puzzles = []
var completed_puzzles = 0
var animation_countdown = 0
var animation_duration = 240

var num_puzzles = 7

var shader_mat : ShaderMaterial

var timeleft = 0




func _ready() -> void:
	# for setting the parameters on win
	shader_mat = $"WorldEnvironment".get_environment().get_sky().get_material()
	for c in $bomb_instance/Games.get_children():
		c.visible = false
	while current_puzzles.size() < num_puzzles: 
		var p = randi_range(0,puzzles.size() - 1)
		var matchh = false
		if !current_puzzles.is_empty():
			for k in current_puzzles:
				if k.id == p + 1:
					matchh = true
		if !matchh:
			var rand
			var unique = false
			while !unique:
				unique = true
				rand = randi_range(0,possible_positions.size() - 1)
				for puzzle in current_puzzles:
					if puzzle.position == possible_positions[rand]:
						unique = false
				if rand < 4 and unique:
					puzzles_on_front += 1
				if puzzles_on_front < 3 and rand > 3:
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
	# loop through all puzzles, count completed
	var local_puzzles_completed = 0 # yes I hate this name too
	for puzzle in current_puzzles:
		if puzzle.completed:
			local_puzzles_completed += 1	
	if local_puzzles_completed > completed_puzzles:
		# fire puzzle completed logic
		completed_puzzles = local_puzzles_completed
		animation_countdown = animation_duration
	if animation_countdown > 0:
		var current_offset:Vector2 = shader_mat.get_shader_parameter("xy_offset")
		var current_angle:float = shader_mat.get_shader_parameter("RotationAngle")
		shader_mat.set_shader_parameter("xy_offset", Vector2(0, current_offset.y + (1.0/animation_duration)))
		shader_mat.set_shader_parameter("RotationAngle", current_angle + (2*PI)/animation_duration)
		animation_countdown -= 1
	else:
		shader_mat.set_shader_parameter("xy_offset", Vector2(0, 0))
		shader_mat.set_shader_parameter("RotationAngle", 0)
	if (fix == false):
		if (puzzles_completed() && !failed):
			timeleft = $TimerNode/Timer.time_left
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

func check_for_achievements():
	print(timeleft)
	if timeleft >= 30:
		Achievements.completed_achievement("Beat game under 1:00")
	if timeleft >= 60:
		Achievements.completed_achievement("Beat game under 30")


func _on_back_button_up() -> void:
	if (allcompleted):
		check_for_achievements()
		SaveManager.pack1owned += 1
		SaveManager.totalxp += 30
	else:
		SaveManager.totalxp += 8
	SaveManager.save()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
