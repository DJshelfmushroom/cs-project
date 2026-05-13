extends Node3D

var id = 3

@onready var original_minigame = preload("res://scenes/puzzles/Hard Puzzles/simon_puzzle_3d_hard.tscn")
var button_scene = preload("res://scenes/components/simon_button_3d.tscn")
var Level = 0
var Color1 = 0
var Color2 = 1
var Color3 = 2
var Color4 = 3
var Color5 = 4
var Color6 = 5
var Color7 = 6
var color8 = 7
var Color9 = 8
var Colors = [Color1, Color2, Color3, Color4, Color5, Color6, Color7, color8, Color9]
var Pattern = [] 
var GameOver = false
var PatternPlaying = false
var AwaitingInputs = false
var ButtonsPressed = []
var GameStart = true
var GameStart2 = false
var completed = false
var setup = false
var practice = true
var started = false
var longmode = false

var FirstTime = 1


func _ready():
	var cap = 4
	if longmode == true:
		cap = 6
	if FirstTime == 1:
		FirstTime = 0
	if !setup:
		setup_buttons()
		$StartGameButton.num = 0
		setup = true
	#_Buttons_Disabled()
	if GameStart2 == true:
		await _Game_Over_Check()
		_Buttons_Disabled()
		if GameOver == false:
			Level = Level + 1
			if (Level < cap):
				for x in range(0, Level + 3):
					Pattern.append(Colors.pick_random())
					
				await get_tree().create_timer(1).timeout
				
				await _play_Pattern()
				GameStart = false	
				_Player_Input()
			else:
				_Win_Animation()
				completed = true

func setup_buttons():
	var button1inst = button_scene.instantiate()
	var button2inst = button_scene.instantiate()
	var button3inst = button_scene.instantiate()
	var button4inst = button_scene.instantiate()
	var button5inst = button_scene.instantiate()
	var button6inst = button_scene.instantiate()
	var button7inst = button_scene.instantiate()
	var button8inst = button_scene.instantiate()
	var button9inst = button_scene.instantiate()
	button1inst.name = "Button"
	button1inst.position = Vector3(-0.175, 0.2, 0.02)
	button1inst.disabled = false
	button2inst.name = "Button2"
	button2inst.position = Vector3(0.175, 0.2, 0.02)
	button2inst.disabled = false
	button3inst.name = "Button3"
	button3inst.position = Vector3(-0.175, -0.15, 0.02)
	button3inst.disabled = false
	button4inst.name = "Button4"
	button4inst.position = Vector3(0.175, -0.15, 0.02)
	button4inst.disabled = false
	button5inst.name = "Button5"
	button5inst.position = Vector3(0.525, 0.2, 0.02)
	button5inst.disabled = false
	button6inst.name = "Button6"
	button6inst.position = Vector3(0.525, -0.15, 0.02)
	button6inst.disabled = false
	button7inst.name = "Button7"
	button7inst.position = Vector3(-0.175, -0.5, 0.02)
	button7inst.disabled = false
	button8inst.name = "Button8"
	button8inst.position = Vector3(0.175, -0.5, 0.02)
	button8inst.disabled = false
	button9inst.name = "Button9"
	button9inst.position = Vector3(0.525, -0.5, 0.02)
	button9inst.disabled = false
	add_child(button1inst)
	add_child(button2inst)
	add_child(button3inst)
	add_child(button4inst)
	add_child(button5inst)
	add_child(button6inst)
	add_child(button7inst)
	add_child(button8inst)
	add_child(button9inst)
	$Button.num = 1
	$Button2.num = 2
	$Button3.num = 3
	$Button4.num = 4
	$Button5.num = 5
	$Button6.num = 6
	$Button7.num = 7
	$Button8.num = 8
	$Button9.num = 9


	
func _play_Pattern():
	PatternPlaying = true
	_Button_Check()
	for x in range (Pattern.size()):
		if Pattern[x] == Color1:
			$Button.set_color(Color.RED)
		if Pattern[x] == Color2:
			$Button2.set_color(Color.BLUE)
		if Pattern[x] == Color3:
			$Button3.set_color(Color.GREEN)
		if Pattern[x] == Color4:
			$Button4.set_color(Color.YELLOW)
		if Pattern[x] == Color5:
			$Button5.set_color(Color.ORANGE)
		if Pattern[x] == Color6:
			$Button6.set_color(Color.PURPLE)
		if Pattern[x] == Color7:
			$Button7.set_color(Color.PINK)
		if Pattern[x] == color8:
			$Button8.set_color(Color.AQUAMARINE)
		if Pattern[x] == Color9:
			$Button9.set_color(Color.SADDLE_BROWN)
			
		await get_tree().create_timer(0.4).timeout
		_Buttons_Off()
		await get_tree().create_timer(0.2).timeout
	PatternPlaying = false
	_Button_Check()
		
func _Button_Check():
	if PatternPlaying == true || GameStart == true  || GameOver == true:
		$Button.ignore_hover = true
		$Button2.ignore_hover = true
		$Button3.ignore_hover = true
		$Button4.ignore_hover = true
		$Button5.ignore_hover = true
		$Button6.ignore_hover = true
		$Button7.ignore_hover = true
		$Button8.ignore_hover = true
		$Button9.ignore_hover = true
	if PatternPlaying == false:
		$Button.ignore_hover = false
		$Button2.ignore_hover = false
		$Button3.ignore_hover = false
		$Button4.ignore_hover = false
		$Button5.ignore_hover = false
		$Button6.ignore_hover = false
		$Button7.ignore_hover = false
		$Button8.ignore_hover = false
		$Button9.ignore_hover = false
		$Button.disabled = false
		$Button2.disabled = false
		$Button3.disabled = false
		$Button4.disabled = false
		$Button5.disabled = false
		$Button6.disabled = false
		$Button7.disabled = false
		$Button8.disabled = false
		$Button9.disabled = false
		_Buttons_Off()
		
func _Buttons_Off():
	$Button.off()
	$Button2.off()
	$Button3.off()
	$Button4.off()
	$Button5.off()
	$Button6.off()
	$Button7.off()
	$Button8.off()
	$Button9.off()
	$Button.ignore_hover = true
	$Button2.ignore_hover = true
	$Button3.ignore_hover = true
	$Button4.ignore_hover = true
	$Button5.ignore_hover = true
	$Button6.ignore_hover = true
	$Button7.ignore_hover = true
	$Button8.ignore_hover = true
	$Button9.ignore_hover = true
	
func _Buttons_Disabled():
	$Button.off()
	$Button2.off()
	$Button3.off()
	$Button4.off()
	$Button5.off()
	$Button6.off()
	$Button7.off()
	$Button8.off()
	$Button9.off()
	$Button.ignore_hover = true
	$Button2.ignore_hover = true
	$Button3.ignore_hover = true
	$Button4.ignore_hover = true
	$Button5.ignore_hover = true
	$Button6.ignore_hover = true
	$Button7.ignore_hover = true
	$Button8.ignore_hover = true
	$Button9.ignore_hover = true
	$Button.disabled = true
	$Button2.disabled = true
	$Button3.disabled = true
	$Button4.disabled = true
	$Button5.disabled = true
	$Button6.disabled = true
	$Button7.disabled = true
	$Button8.disabled = true
	$Button9.disabled = true

func _Player_Input():

	if PatternPlaying == false:
		AwaitingInputs = true
			
	
func _Game_Over():
	_Buttons_Disabled()
	await _Game_Over_Animation()

	
func _Game_Over_Check():
	if GameOver == true:
		await _Game_Over()	
	
func _Game_Over_Animation():
	$Button.set_color(Color.RED)
	$Button2.set_color(Color.RED)
	$Button3.set_color(Color.RED)
	$Button4.set_color(Color.RED)
	$Button5.set_color(Color.RED)
	$Button6.set_color(Color.RED)
	$Button7.set_color(Color.RED)
	$Button8.set_color(Color.RED)
	$Button9.set_color(Color.RED)
	await get_tree().create_timer(0.4).timeout
	_Buttons_Off()
	await get_tree().create_timer(0.4).timeout
	$Button.set_color(Color.RED)
	$Button2.set_color(Color.RED)
	$Button3.set_color(Color.RED)
	$Button4.set_color(Color.RED)
	$Button5.set_color(Color.RED)
	$Button6.set_color(Color.RED)
	$Button7.set_color(Color.RED)
	$Button8.set_color(Color.RED)
	$Button9.set_color(Color.RED)
	await get_tree().create_timer(0.4).timeout
	_Buttons_Off()
	$"../../..".strikes += 1
	await get_tree().create_timer(1.0).timeout
	$"../../..".fix = true
	var parent = get_parent()
	var new_minigame = original_minigame.instantiate()
	name = "Simon"
	new_minigame.name = "SimonPuzzle3D"
	new_minigame.scale.x = scale.x
	new_minigame.scale.y = scale.y
	new_minigame.scale.z = scale.z
	new_minigame.position = position
	new_minigame.rotation = rotation
	new_minigame.practice = false
	parent.add_child(new_minigame)
	for p in range($"../../..".current_puzzles.size()):
		if $"../../..".current_puzzles[p].id == id:
			$"../../..".current_puzzles.remove_at(p)
			break
	$"../../..".current_puzzles.append(new_minigame)
	queue_free()

func _Win_Animation():
	$Button.set_color(Color.GREEN)
	$Button2.set_color(Color.GREEN)
	$Button3.set_color(Color.GREEN)
	$Button4.set_color(Color.GREEN)
	$Button5.set_color(Color.GREEN)
	$Button6.set_color(Color.GREEN)
	$Button7.set_color(Color.GREEN)
	$Button8.set_color(Color.GREEN)
	$Button9.set_color(Color.GREEN)
	await get_tree().create_timer(0.4).timeout
	_Buttons_Off()
	await get_tree().create_timer(0.4).timeout
	$Button.set_color(Color.GREEN)
	$Button2.set_color(Color.GREEN)
	$Button3.set_color(Color.GREEN)
	$Button4.set_color(Color.GREEN)
	$Button5.set_color(Color.GREEN)
	$Button6.set_color(Color.GREEN)
	$Button7.set_color(Color.GREEN)
	$Button8.set_color(Color.GREEN)
	$Button9.set_color(Color.GREEN)


func _on_but_pressed(num : int) -> void:
	if !started:
		#if !$"../../..".failed:
			started = true
			GameStart2 = true
			$StartGameButton.disabled = true
			_ready()
	
	else:
		if num == 1:
			if AwaitingInputs == true:
				ButtonsPressed.append(0)
			$Button.off()
			if ButtonsPressed.size() == Pattern.size():
				_Buttons_Off()
				if ButtonsPressed == Pattern:
					Pattern.clear()
					ButtonsPressed.clear()
					_ready()
				else:
					GameOver = true
					_ready()
		elif num == 2:
			if AwaitingInputs == true:
				ButtonsPressed.append(1)
			$Button2.off()
			if ButtonsPressed.size() == Pattern.size():
				_Buttons_Off()
				if ButtonsPressed == Pattern:
					Pattern.clear()
					ButtonsPressed.clear()
					_ready()
				else:
					GameOver = true
					_ready()
		elif num == 3:
			if AwaitingInputs == true:
				ButtonsPressed.append(2)
			$Button3.off()
			if ButtonsPressed.size() == Pattern.size():
				_Buttons_Off()
				if ButtonsPressed == Pattern:
					Pattern.clear()
					ButtonsPressed.clear()
					_ready()
				else:
					GameOver = true
					_ready()
		elif num == 4:
			if AwaitingInputs == true:
				ButtonsPressed.append(3)
			$Button4.off()
			if ButtonsPressed.size() == Pattern.size():
				_Buttons_Off()
				if ButtonsPressed == Pattern:
					Pattern.clear()
					ButtonsPressed.clear()
					_ready()
				else:
					GameOver = true
					_ready()
		elif num == 5:
			if AwaitingInputs == true:
				ButtonsPressed.append(4)
			$Button5.off()
			if ButtonsPressed.size() == Pattern.size():
				_Buttons_Off()
				if ButtonsPressed == Pattern:
					Pattern.clear()
					ButtonsPressed.clear()
					_ready()
				else:
					GameOver = true
					_ready()
		elif num == 6:
			if AwaitingInputs == true:
				ButtonsPressed.append(5)
			$Button6.off()
			if ButtonsPressed.size() == Pattern.size():
				_Buttons_Off()
				if ButtonsPressed == Pattern:
					Pattern.clear()
					ButtonsPressed.clear()
					_ready()
				else:
					GameOver = true
					_ready()
		elif num == 7:
			if AwaitingInputs == true:
				ButtonsPressed.append(6)
			$Button7.off()
			if ButtonsPressed.size() == Pattern.size():
				_Buttons_Off()
				if ButtonsPressed == Pattern:
					Pattern.clear()
					ButtonsPressed.clear()
					_ready()
				else:
					GameOver = true
					_ready()
		elif num == 8:
			if AwaitingInputs == true:
				ButtonsPressed.append(7)
			$Button8.off()
			if ButtonsPressed.size() == Pattern.size():
				_Buttons_Off()
				if ButtonsPressed == Pattern:
					Pattern.clear()
					ButtonsPressed.clear()
					_ready()
				else:
					GameOver = true
					_ready()
		elif num == 9:
			if AwaitingInputs == true:
				ButtonsPressed.append(8)
			$Button9.off()
			if ButtonsPressed.size() == Pattern.size():
				_Buttons_Off()
				if ButtonsPressed == Pattern:
					Pattern.clear()
					ButtonsPressed.clear()
					_ready()
				else:
					GameOver = true
					_ready()
		
			
func _on_but_released(_num : int):
	pass


func _on_red_wire_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/practice_menu.tscn")
