extends Node3D

var puzzles = [preload("res://scenes/puzzles/puzzle_one_3d.tscn"), preload("res://scenes/puzzles/puzzle_two_3d.tscn"), preload("res://scenes/puzzles/simon_puzzle_3d.tscn"),
preload("res://scenes/puzzles/reflex_puzzle_3d.tscn"), preload("res://scenes/puzzles/numerle_puzzle_3d.tscn"), preload("res://scenes/puzzles/segment_puzzle_3d.tscn"), 
preload("res://scenes/puzzles/disable_puzzle_3d.tscn"), preload("res://scenes/puzzles/colors_puzzle_3d.tscn"), preload("res://scenes/puzzles/switches_puzzle_3d.tscn"),
preload("res://scenes/puzzles/yes_no_puzzle_3d.tscn"), preload("res://scenes/puzzles/target_puzzle_3d.tscn"), preload("res://scenes/puzzles/track_puzzle_3d.tscn"), 
preload("res://scenes/puzzles/shift_puzzle_3d_easy.tscn"), preload("res://scenes/puzzles/Operation3D.tscn"), preload("res://scenes/puzzles/color_theory_puzzle.tscn")]

var hard_puzzles = [preload("res://scenes/puzzles/Hard Puzzles/puzzle_one_3d_hard.tscn"),preload("res://scenes/puzzles/Hard Puzzles/puzzle_two_3d_hard.tscn"),
preload("res://scenes/puzzles/Hard Puzzles/simon_puzzle_3d_hard.tscn"), preload("res://scenes/puzzles/reflex_puzzle_3d.tscn"), 
preload("res://scenes/puzzles/Hard Puzzles/numerle_puzzle_3d_hard.tscn"), preload("res://scenes/puzzles/Hard Puzzles/segment_puzzle_3dh.tscn"),
preload("res://scenes/puzzles/disable_puzzle_3d.tscn"), preload("res://scenes/puzzles/Hard Puzzles/colors_puzzle_3d_hard.tscn"), 
preload("res://scenes/puzzles/switches_puzzle_3d.tscn"), preload("res://scenes/puzzles/yes_no_puzzle_3d.tscn"), preload("res://scenes/puzzles/Hard Puzzles/target_puzzle_3d_hard.tscn"),
preload("res://scenes/puzzles/track_puzzle_3d.tscn"), preload("res://scenes/puzzles/Hard Puzzles/shift_puzzle_3d.tscn"), preload("res://scenes/puzzles/Hard Puzzles/Operation3D HARD.tscn"),
preload("res://scenes/puzzles/color_theory_puzzle.tscn")]


var puzzle_scales = [0.45,0.4,0.5,0.5,0.4,0.35,0.2,0.6,0.08,0.17,0.2,0.2,0.25,0.00075, 0.6]
var hard_puzzle_scales = [0.45,0.27,0.35,0.5,0.5,0.35,0.2,0.6,0.08,0.17,0.2,0.2,0.25,0.00075,0.6]
var puzzle_weights = [1,5,4,4,2,1,2,2,2,3,2,2,10,4,2] #Value of how hard/time-consuming each puzzle is, will eventually be used to determine what puzzles you get
var hard_puzzle_weights = [6,15,6,4,14,3,1,4,2,3,3,2,11,8,2]
var weights_left = puzzle_weights.duplicate()
var hard_weights_left = hard_puzzle_weights.duplicate()

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
var finalstrikes
var failed = false
var allcompleted = false
var fix = false
var disable_first = false

# BS Animation vars
var current_puzzles = []
var completed_puzzles = 0
var animation_countdown = 0.0
var animation_duration = 240.0
var shader_mat : ShaderMaterial
var default_xy : Vector2
var default_rot : float

# for the glass break
var broken = false


var weight = SaveManager.level * 4 + 5

var numhardpuzzles = floor(SaveManager.level / 5.0) # WHY IS IT GIVING WARNINGS

var time
var addedxp
var timeleft = 0
var once = false
var current_weight = 0
var is_practice = false

func Strike() -> void:
	Utils.LogGD("strike", self)
	strikes += 1;

func _unhandled_input(event: InputEvent) -> void:
	if Utils.GetDebug():
		if event.is_action_pressed("ui_page_up"):
			$TimerNode/Timer.paused = true

func _ready() -> void:
	shader_mat = $"WorldEnvironment".get_environment().get_sky().get_material()
	default_xy = shader_mat.get_shader_parameter("xy_offset")
	default_rot = shader_mat.get_shader_parameter("RotationAngle")

	for c in $bomb_instance/Games.get_children():
		c.visible = false
		
	# Special practice mode handling
	if (SaveManager.practice):
		SaveManager.practice = false
		is_practice = true
		var p = SaveManager.practice_puzzle_index
		var puzzle: Node3D = hard_puzzles[p].instantiate() if SaveManager.practice_hard else puzzles[p].instantiate()
		puzzle.position = possible_positions[0]  # front-face slot
		puzzle.scale = Vector3(puzzle_scales[p], puzzle_scales[p], puzzle_scales[p])
		puzzle.rotation = rotations[0]
		$"bomb_instance/Games".add_child(puzzle)
		current_puzzles.append(puzzle)
		strikes = 0
		$ReturnButton.visible = true
		return

	while current_weight < weight && current_puzzles.size() < 20: 
		var cont = false
		
		var skip = true
		for w in hard_puzzle_weights:
			if w < weight - current_weight:
				skip = false
			
		if skip:
			numhardpuzzles = 0
		
		if numhardpuzzles > 0:
			for w in hard_weights_left:
				if w <= weight - current_weight:
					cont = true
					break

			if !cont:
				break

			var valid_indices = []
			for i in range(hard_puzzles.size()):
				if hard_puzzle_weights[i] <= weight - current_weight:
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


			hard_weights_left.erase(hard_puzzle_weights[p])
			current_weight += hard_puzzle_weights[p]

			var puzzle_inst = hard_puzzles[p].instantiate()
			puzzle_inst.position = possible_positions[rand]
			puzzle_inst.scale = Vector3(hard_puzzle_scales[p],hard_puzzle_scales[p],hard_puzzle_scales[p])

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
			
			if puzzle_inst.id != 4 && puzzle_inst.id != 7 && puzzle_inst.id != 9 && puzzle_inst.id != 10 && puzzle_inst.id != 12 && puzzle_inst.id != 15:
				numhardpuzzles -= 1
			
		else:

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


			weights_left.erase(puzzle_weights[p])
			current_weight += puzzle_weights[p]

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
	time = weight * 3 + 5
	$TimerNode.start_timer(time)

func _process(_delta: float) -> void:
	# loop through all puzzles, count completed
	var local_puzzles_completed = 0 # yes I hate this name too
	default_xy += Vector2(0.00001, 0) if animation_countdown <= 0.0 else Vector2(0, 0)
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
		animation_countdown = 0.0 if cancel else animation_duration
	if animation_countdown > 0.01:
		#var current_offset:Vector2 = shader_mat.get_shader_parameter("xy_offset")
		var current_angle:float = shader_mat.get_shader_parameter("RotationAngle")
		#shader_mat.set_shader_parameter("xy_offset", Vector2(current_offset.x, current_offset.y + (1.0/animation_duration)))
		shader_mat.set_shader_parameter("RotationAngle", current_angle + (((2*PI)/animation_duration)*_delta*144))
		animation_countdown -= 1 * _delta * 144
	#else:
		#shader_mat.set_shader_parameter("xy_offset", default_xy)
		#shader_mat.set_shader_parameter("RotationAngle", default_rot)
	
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
			finalstrikes = strikes
			$RedWireButton.visible = true
	else:
		fix = false
		
	if (strikes >= 3 || (!is_practice && $TimerNode/Timer.time_left <= 0 && !allcompleted)):
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
	if timeleft >= (time / 4):
		Achievements.completed_achievement("Beat game with fourth left")
	if timeleft >= (time / 3):
		Achievements.completed_achievement("Beat game with third left")


func _on_back_button_up() -> void:
	if !is_practice:
		if (allcompleted):
			check_for_achievements()
			var rand = randi_range(1,10)
			if rand == 10:
				SaveManager.pack1owned += 2
			else:
				SaveManager.pack1owned += 1
			SaveManager.addedxp = current_weight * 2 * (1 + timeleft / (weight * 3)) + 5 * (3 - finalstrikes)
			SaveManager.totalxp += SaveManager.addedxp
		else:
			SaveManager.addedxp = current_weight / 2
			SaveManager.totalxp += SaveManager.addedxp
		SaveManager.save()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
