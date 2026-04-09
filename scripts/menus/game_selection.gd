extends Node3D

var puzzles = [preload("res://scenes/puzzles/puzzle_one_3d.tscn"), preload("res://scenes/puzzles/puzzle_two_3d.tscn"), preload("res://scenes/puzzles/simon_puzzle_3d.tscn"),
preload("res://scenes/puzzles/reflex_puzzle_3d.tscn"), preload("res://scenes/puzzles/numerle_puzzle_3d.tscn"), preload("res://scenes/puzzles/segment_puzzle_3d.tscn"), 
preload("res://scenes/puzzles/disable_puzzle_3d.tscn"), preload("res://scenes/puzzles/colors_puzzle_3d.tscn"), preload("res://scenes/puzzles/switches_puzzle_3d.tscn"),
preload("res://scenes/puzzles/yes_no_puzzle_3d.tscn"), preload("res://scenes/puzzles/target_puzzle_3d.tscn"), preload("res://scenes/puzzles/track_puzzle_3d.tscn"), 
preload("res://scenes/puzzles/shift_puzzle_3d.tscn")]


var puzzle_scales = [0.45,0.4,0.5,0.5,0.4,0.35,0.2,0.6,0.08,0.17,0.2,0.2,0.25]

var puzzle_weights = [2,4,3,4,2,2,1,3,2,4,3,3,8] #Value of how hard/time-consuming each puzzle is, will eventually be used to determine what puzzles you get
var weights_left =   [2,4,3,3,2,2,1,3,2,4,3,3,8]

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

# BS Animation vars
var current_puzzles = []
var completed_puzzles = 0
var animation_countdown = 0
var animation_duration = 240
var shader_mat : ShaderMaterial
var default_xy : Vector2
var default_rot : float

# for the glass break
var broken = false


var weight = SaveManager.level * 2 + 5


var timeleft = 0
var once = false
var current_weight = 0

func Strike() -> void:
	Utils.LogGD("strike", self)
	strikes += 1;


func _ready() -> void:
	shader_mat = $"WorldEnvironment".get_environment().get_sky().get_material()
	default_xy = shader_mat.get_shader_parameter("xy_offset")
	default_rot = shader_mat.get_shader_parameter("RotationAngle")

	for c in $bomb_instance/Games.get_children():
		c.visible = false

	while current_weight < weight && current_puzzles.size() < 20: 
		var cont = false

		for w in weights_left:
			if w <= weight - current_weight:
				cont = true
				break

		if !cont:
			break

		var valid_indices = []
		for i in range(puzzles.size()):
			if puzzle_weights[i] <= weight - current_weight:
				var matchh = false
				for k in current_puzzles:
					if k.id == i + 1:
						matchh = true
						break
				if !matchh:
					valid_indices.append(i)

		if valid_indices.is_empty():
			break

		var p = valid_indices.pick_random()

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

		weights_left.erase(puzzle_weights[p])
		current_weight += puzzle_weights[p]

	strikes = 0
	$TimerNode.start_timer(weight * 4)

func _process(_delta: float) -> void:
	# loop through all puzzles, count completed
	var local_puzzles_completed = 0 # yes I hate this name too
	default_xy += Vector2(0.00001, 0) if animation_countdown == 0 else Vector2(0, 0)
	var env : WorldEnvironment = $"WorldEnvironment"
	env.environment.sky_rotation = $"bomb_instance".GetBombRotation()
	shader_mat.set_shader_parameter("xy_offset", default_xy)
	default_xy = Vector2(wrapf(default_xy.x, 0, 1), wrapf(default_xy.y, 0, 1))
	for puzzle in current_puzzles:
		if puzzle.completed:
			local_puzzles_completed += 1
	if local_puzzles_completed > completed_puzzles:
		var cancel := current_puzzles.any(func(p): return p.id == 7 && !p.completed)
		# fire puzzle completed logic
		completed_puzzles = local_puzzles_completed
		animation_countdown = 0 if cancel else animation_duration
	if animation_countdown > 0:
		var current_offset:Vector2 = shader_mat.get_shader_parameter("xy_offset")
		var current_angle:float = shader_mat.get_shader_parameter("RotationAngle")
		shader_mat.set_shader_parameter("xy_offset", Vector2(0, current_offset.y + (1.0/animation_duration)))
		shader_mat.set_shader_parameter("RotationAngle", current_angle + (2*PI)/animation_duration)
		animation_countdown -= 1
	else:
		shader_mat.set_shader_parameter("xy_offset", default_xy)
		shader_mat.set_shader_parameter("RotationAngle", default_rot)
	
	if(!broken):
		if(strikes >= 3):
			$"TextureRect".visible = true;
			broken = true
	if (fix == false):
		if (puzzles_completed() && !failed):
			if (once == false):
				timeleft = $TimerNode/Timer.time_left
			once = true
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
				Achievements.completed_achievement("Don't disable the puzzle")
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
	if timeleft >= 30:
		Achievements.completed_achievement("Beat game under 1:30")
	if timeleft >= 60:
		Achievements.completed_achievement("Beat game under 1:00")


func _on_back_button_up() -> void:
	if (allcompleted):
		var rand = randi_range(1,10)
		if rand == 10:
			SaveManager.pack1owned += 2
		else:
			SaveManager.pack1owned += 1
		SaveManager.totalxp += current_weight * 2 * (1 + timeleft / (weight * 3)) + 5 * (3 - strikes)
	else:
		SaveManager.totalxp += current_weight / 2
	SaveManager.save()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
