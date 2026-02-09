extends Node3D

@onready var original_minigame = preload("res://scenes/puzzles/simon_puzzle_3d.tscn")
var button_scene = preload("res://scenes/components/simon_button_3d.tscn")
var Level = 0
var Color1 = 0
var Color2 = 1
var Color3 = 2
var Color4 = 3
var Colors = [Color1, Color2, Color3, Color4]
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

var FirstTime = 1

func _process(_delta: float) -> void:
	if (completed && practice):
		$RedWireButton.visible = true

func _ready():
	if FirstTime == 1:
		FirstTime = 0
	if !setup:
		var button1inst = button_scene.instantiate()
		var button2inst = button_scene.instantiate()
		var button3inst = button_scene.instantiate()
		var button4inst = button_scene.instantiate()
		button1inst.name = "Button"
		button1inst.position = Vector3(0, 0.35, 0)
		button1inst.disabled = true
		button2inst.name = "Button2"
		button2inst.position = Vector3(0.35, 0.35, 0)
		button2inst.disabled = true
		button3inst.name = "Button3"
		button3inst.position = Vector3(0, 0, 0)
		button3inst.disabled = true
		button4inst.name = "Button4"
		button4inst.position = Vector3(0.35, 0, 0)
		button4inst.disabled = true
		add_child(button1inst)
		add_child(button2inst)
		add_child(button3inst)
		add_child(button4inst)
		$Button.num = 1
		$Button2.num = 2
		$Button3.num = 3
		$Button4.num = 4
		$Button3.set_color(Color.AQUA)
		$StartGameButton.num = 0
		setup = true
	_Buttons_Disabled()
	if GameStart2 == true:
		await _Game_Over_Check()
		_Buttons_Disabled()
		if GameOver == false:
			Level = Level + 1
			if (Level < 3):
				for x in range(0, Level + 3):
					Pattern.append(Colors.pick_random())
					
				await get_tree().create_timer(1).timeout
				
				await _play_Pattern()
				GameStart = false	
				_Player_Input()
			else:
				await _Win_Animation()
				completed = true

	
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
			
		await get_tree().create_timer(0.5).timeout
		_Buttons_Off()
		await get_tree().create_timer(0.5).timeout
	PatternPlaying = false
	_Button_Check()
		
func _Button_Check():
	if PatternPlaying == true || GameStart == true  || GameOver == true:
		$Button.ignore_hover = true
		$Button2.ignore_hover = true
		$Button3.ignore_hover = true
		$Button4.ignore_hover = true
	if PatternPlaying == false:
		$Button.ignore_hover = false
		$Button2.ignore_hover = false
		$Button3.ignore_hover = false
		$Button4.ignore_hover = false
		$Button.disabled = false
		$Button2.disabled = false
		$Button3.disabled = false
		$Button4.disabled = false
		_Buttons_Off()
		
func _Buttons_Off():
	$Button.off()
	$Button2.off()
	$Button3.off()
	$Button4.off()
	$Button.ignore_hover = true
	$Button2.ignore_hover = true
	$Button3.ignore_hover = true
	$Button4.ignore_hover = true
	
func _Buttons_Disabled():
	$Button.off()
	$Button2.off()
	$Button3.off()
	$Button4.off()
	$Button.ignore_hover = true
	$Button2.ignore_hover = true
	$Button3.ignore_hover = true
	$Button4.ignore_hover = true
	$Button.disabled = true
	$Button2.disabled = true
	$Button3.disabled = true
	$Button4.disabled = true

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
	await get_tree().create_timer(0.4).timeout
	_Buttons_Off()
	await get_tree().create_timer(0.4).timeout
	$Button.set_color(Color.RED)
	$Button2.set_color(Color.RED)
	$Button3.set_color(Color.RED)
	$Button4.set_color(Color.RED)
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
	queue_free()

func _Win_Animation():
	$Button.set_color(Color.GREEN)
	$Button2.set_color(Color.GREEN)
	$Button3.set_color(Color.GREEN)
	$Button4.set_color(Color.GREEN)
	await get_tree().create_timer(0.4).timeout
	_Buttons_Off()
	await get_tree().create_timer(0.4).timeout
	$Button.set_color(Color.GREEN)
	$Button2.set_color(Color.GREEN)
	$Button3.set_color(Color.GREEN)
	$Button4.set_color(Color.GREEN)


func _on_but_pressed(num : int) -> void:
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
	else:
		if !$"../../..".failed:
			GameStart2 = true
			$StartGameButton.disabled = true
			_ready()
			
func _on_but_released(_num : int):
	pass


func _on_red_wire_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/practice_menu.tscn")
