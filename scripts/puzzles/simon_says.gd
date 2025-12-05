extends Node2D

@onready var original_minigame = preload("res://scenes/puzzles/simon_says.tscn")
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
var practice = true

#var FirstTime = 1

func _process(_delta: float) -> void:
	if (completed && practice):
		$RedWireButton.visible = true

func _ready():
	#if FirstTime == 1:
	#	await _Start_Game()
	#	FirstTime = 0
	#	$StartGameButton.hide()
	_Buttons_Off()
	if GameStart2 == true:
		await _Game_Over_Check()
		_Buttons_Dark()
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
	
func _Button1():
	var Button1_color = $Button.get_theme_stylebox("normal").duplicate()
	$Button.add_theme_stylebox_override("normal", Button1_color)
	return Button1_color
	
func _Button2():
	var Button2_color = $Button2.get_theme_stylebox("normal").duplicate()
	$Button2.add_theme_stylebox_override("normal", Button2_color)
	return Button2_color
	
func _Button3():
	var Button3_color = $Button3.get_theme_stylebox("normal").duplicate()
	$Button3.add_theme_stylebox_override("normal", Button3_color)
	return Button3_color
 
func _Button4():
	var Button4_color = $Button4.get_theme_stylebox("normal").duplicate()
	$Button4.add_theme_stylebox_override("normal", Button4_color)
	return Button4_color
	

#func _Start_Game():
#	await GameStart2 == true
	
func _play_Pattern():
	PatternPlaying = true
	_Button_Check()
	for x in range (Pattern.size()):
		if Pattern[x] == Color1:
			_Button1().bg_color = Color.RED
		if Pattern[x] == Color2:
			_Button2().bg_color = Color.BLUE
		if Pattern[x] == Color3:
			_Button3().bg_color = Color.WEB_GREEN
		if Pattern[x] == Color4:
			_Button4().bg_color = Color.YELLOW
			
		await get_tree().create_timer(0.5).timeout
		_Buttons_Dark()
		await get_tree().create_timer(0.5).timeout
	PatternPlaying = false
	_Button_Check()
		
func _Button_Check():
	if PatternPlaying == true || GameStart == true  || GameOver == true:
		$Button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$Button2.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$Button3.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$Button4.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if PatternPlaying == false:
		$Button.mouse_filter = Control.MOUSE_FILTER_STOP
		$Button2.mouse_filter = Control.MOUSE_FILTER_STOP
		$Button3.mouse_filter = Control.MOUSE_FILTER_STOP
		$Button4.mouse_filter = Control.MOUSE_FILTER_STOP
		_Button1().bg_color = Color.WEB_GRAY
		_Button2().bg_color = Color.WEB_GRAY
		_Button3().bg_color = Color.WEB_GRAY
		_Button4().bg_color = Color.WEB_GRAY
		
func _Buttons_Off():
	$Button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Button2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Button3.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Button4.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
func _Buttons_Dark():
	_Button1().bg_color = Color.DIM_GRAY
	_Button2().bg_color = Color.DIM_GRAY
	_Button3().bg_color = Color.DIM_GRAY
	_Button4().bg_color = Color.DIM_GRAY

func _Player_Input():

	if PatternPlaying == false:
		AwaitingInputs = true
			
	
func _Game_Over():
	_Buttons_Off()
	await _Game_Over_Animation()

	
func _Game_Over_Check():
	if GameOver == true:
		await _Game_Over()	
	
func _Game_Over_Animation():
	_Button1().bg_color = Color.RED
	_Button2().bg_color = Color.RED
	_Button3().bg_color = Color.RED
	_Button4().bg_color = Color.RED
	await get_tree().create_timer(0.4).timeout
	_Button4().bg_color = Color.RED
	await get_tree().create_timer(0.4).timeout
	_Button1().bg_color = Color.WEB_GRAY
	_Button2().bg_color = Color.WEB_GRAY
	_Button3().bg_color = Color.WEB_GRAY
	_Button4().bg_color = Color.WEB_GRAY
	await get_tree().create_timer(0.4).timeout
	_Button1().bg_color = Color.RED
	_Button2().bg_color = Color.RED
	_Button3().bg_color = Color.RED
	_Button4().bg_color = Color.RED
	await get_tree().create_timer(0.4).timeout
	_Buttons_Dark()
	$"..".strikes += 1
	await get_tree().create_timer(1.0).timeout
	$"..".fix = true
	var parent = get_parent()
	var new_minigame = original_minigame.instantiate()
	name = "Simon"
	new_minigame.name = "Simon Says"
	new_minigame.scale.x = 0.5
	new_minigame.scale.y = 0.5
	new_minigame.position = Vector2(820,0)
	new_minigame.practice = false
	parent.add_child(new_minigame)
	queue_free()

func _Win_Animation():
	_Button1().bg_color = Color.GREEN
	_Button2().bg_color = Color.GREEN
	_Button3().bg_color = Color.GREEN
	_Button4().bg_color = Color.GREEN
	await get_tree().create_timer(0.4).timeout
	_Button1().bg_color = Color.WEB_GRAY
	_Button2().bg_color = Color.WEB_GRAY
	_Button3().bg_color = Color.WEB_GRAY
	_Button4().bg_color = Color.WEB_GRAY
	await get_tree().create_timer(0.4).timeout
	_Button1().bg_color = Color.GREEN
	_Button2().bg_color = Color.GREEN
	_Button3().bg_color = Color.GREEN
	_Button4().bg_color = Color.GREEN


func _on_button_pressed() -> void:
	if AwaitingInputs == true:
		ButtonsPressed.append(0)
	_Button1().bg_color = Color.WEB_GRAY
	if ButtonsPressed.size() == Pattern.size():
		_Buttons_Off()
		if ButtonsPressed == Pattern:
			Pattern.clear()
			ButtonsPressed.clear()
			_ready()
		else:
			GameOver = true
			_ready()

func _on_button_1_pressed() -> void:
	if AwaitingInputs == true:
		ButtonsPressed.append(1)
	_Button2().bg_color = Color.WEB_GRAY
	if ButtonsPressed.size() == Pattern.size():
		_Buttons_Off()
		if ButtonsPressed == Pattern:
			Pattern.clear()
			ButtonsPressed.clear()
			_ready()
		else:
			GameOver = true
			_ready()

func _on_button_2_pressed() -> void:
	if AwaitingInputs == true:
		ButtonsPressed.append(2)
	_Button3().bg_color = Color.WEB_GRAY
	if ButtonsPressed.size() == Pattern.size():
		_Buttons_Off()
		if ButtonsPressed == Pattern:
			Pattern.clear()
			ButtonsPressed.clear()
			_ready()
		else:
			GameOver = true
			_ready()

func _on_button_3_pressed() -> void:
	if AwaitingInputs == true:
		ButtonsPressed.append(3)
	_Button4().bg_color = Color.WEB_GRAY
	if ButtonsPressed.size() == Pattern.size():
		_Buttons_Off()
		if ButtonsPressed == Pattern:
			Pattern.clear()
			ButtonsPressed.clear()
			_ready()
		else:
			GameOver = true
			_ready()


func _on_start_game_button_up() -> void:
	GameStart2 = true
	$StartGameButton.disabled = true
	_ready()


func _on_red_wire_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/practice_menu.tscn")
