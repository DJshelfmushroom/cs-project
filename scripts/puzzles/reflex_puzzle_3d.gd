extends Node3D

var id = 4

var GameStart = false
@onready var Labels = [$Up, $Down, $Left, $Right]
var label = null
var processinstruction = null
var checkKeys = false
var awaitingInputs = false
var keyPressed = null
const keys : Dictionary = {
	"up": 0,
	"down": 1,
	"left": 2,
	"right": 3
}
var score = 0
@onready var timer = $Timer
#@onready var screen_size = get_viewport().get_visible_rect()
var completed = false
var longmode = false
var scoreToWin = 20
var easter_egg = [0, 0, 1, 1, 2, 3, 2, 3]
var egg_list = []
var basket_filled = false
var key_list = []
var code_confirmed = false
var once = false

func set_start_button():
	$StartButton.set_text("START")
	$StartButton/button/Label3D.modulate = Color.WHITE
	$StartButton/button/Label3D.font_size = 220
	$StartButton/button/Label3D.pixel_size = 0.00025
	$StartButton.index = 0
	
func set_restart_button():
	$RestartButton3D.set_text("RESTART?")
	$RestartButton3D/button/Label3D.modulate = Color.WHITE
	$RestartButton3D/button/Label3D.font_size = 220
	$RestartButton3D/button/Label3D.pixel_size = 0.00025
	$RestartButton3D.index = 1

func _ready():
	basket_filled = false
	code_confirmed = false
	scoreToWin = 20
	if longmode == true:
		scoreToWin = 30
	set_start_button()
	set_restart_button()
	$EndScreen.hide()
	$Score.hide()
	$RestartButton3D.hide()
	$Time.hide()
	$StartButton.show()
	hideLabels()
	reset_labels()
	#set_label_Size()
	place_labels()
	prepare_timer()
	score = 0
	$Screen3D.position = Vector3(-0.117, -0.117, 0.001)
	$Screen3D.set_size(4,3)
	
	
func setup_fix():
	set_start_button()
	set_restart_button()
	$EndScreen.hide()
	$Score.hide()
	$RestartButton3D.hide()
	$Time.hide()
	$StartButton.show()
	hideLabels()
	reset_labels()
	place_labels()
	prepare_timer()
	score = 0
	$Screen3D.position = Vector3(-0.117, -0.117, 0.001)
	$Screen3D.set_size(4,3)
	
#func set_label_Size():
#	for x in Labels:
#		x.size = Vector2(300, 260)
	
func prepare_timer():
	timer.wait_time = 11
	if longmode == true:
		timer.wait_time = 16
	timer.one_shot = true
	
func _process(_delta: float):
	#if (completed && practice):
	#	$RedWireButton.visible = true
		
	if basket_filled == true && key_list.size() == 3:
		if key_list[0] == "B" && key_list[1] == "A" && key_list[2] == "ENTER":
			code_confirmed = true
	
	if (time_left() >= 0):
		if (time_left() >= 10):
			$Time.text = str(time_left())
		if (time_left() < 10):
			$Time.text = "0" + str(time_left())
	if awaitingInputs:
		if processinstruction == keys.up:
			
			if (label_on_screen(label) == true):
				label.position.y += 0.015 * _delta * 150
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()
			
		elif processinstruction == keys.down:
			
			if (label_on_screen(label) == true):
				label.position.y -= 0.015 * _delta * 150
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()

		elif processinstruction == keys.left:
			
			if (label_on_screen(label) == true):
				label.position.x -= 0.02 * _delta * 150
			else:
				
				processinstruction = null
				awaitingInputs = false
				_startGame()			
				
		elif processinstruction == keys.right:
			
			if (label_on_screen(label) == true):
				label.position.x += 0.02 * _delta * 150
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()
				
	if Input.is_action_just_pressed("key_b"):
			if code_confirmed != true:
				if basket_filled == true && key_list.size() == 0:
					key_list.append("B")
				else:
					key_list.clear()
					egg_list.clear()
					basket_filled = false
				
	if Input.is_action_just_pressed("key_a"):
		if code_confirmed != true:
			if basket_filled == true && key_list.size() == 1 && key_list[0] == "B":
				key_list.append("A")
			else:
				key_list.clear()
				egg_list.clear()
				basket_filled = false
				
	if Input.is_action_just_pressed("key_enter"):
		if code_confirmed != true:
			if basket_filled == true && key_list.size() == 2 && key_list[0] == "B" && key_list[1] == "A":
				key_list.append("ENTER")
			else:
				key_list.clear()
				egg_list.clear()
				basket_filled = false
				
	if GameStart:
		if score >= scoreToWin || time_left() <= 0:
			hideLabels()
			$Time.hide()
			if score < scoreToWin:
				lose()
			else:
				win()	
	if code_confirmed == true:
		Achievements.completed_achievement("It's a me")
		if once == false:
			SaveManager.arrow = load("res://assets/cursor/Secret_RedWire_Cursor.png")
			SaveManager.hand  = load("res://assets/cursor/Secret_RedWire_Hand.png")
			SaveManager.color = "secret"

			$CustomCursor.set_mouse_cursor(SaveManager.arrow, SaveManager.hand, "secret")
			once = true
			SaveManager.save()

func _process_instruction(key):
	processinstruction = key

func place_labels():
	for x in Labels:
		x.position = Vector3(0,0, 0.002)

func reset_labels():
	for x in Labels:
		x.modulate = Color.WHITE

func time_left():
	return int(timer.get_time_left())

func label_on_screen(word):
	
	return (
		(word.position.y <= 0.293 and word.position.y >= -0.28) and (word.position.x <= 0.3 and word.position.x >= -0.3)
	)

func begin():
	label = null
	processinstruction = null
	checkKeys = false
	awaitingInputs = false
	keyPressed = null
	
func check_egg():
	if code_confirmed != true:
		if egg_list.size() > 0 && egg_list.size() < easter_egg.size():
			var x = 0
			while x < egg_list.size():
				if int(egg_list[x]) != int(easter_egg[x]):
					egg_list.clear()
					break
				x += 1
		elif egg_list.size() == easter_egg.size():
			basket_filled = true

func _startGame():
	check_egg()
	hideLabels()
	reset_labels()
	place_labels()
	begin()
	$Time.show()
	if GameStart and !completed:
		label = Labels.pick_random()
		label.show()
		checkKeys = true
	#if (time_left() <= 0):
	#	hideLabels()
	#	if (score >= 16):
	#		win()
	#	else:
	#		lose()

func _unhandled_input(event):
		if !checkKeys or completed or $"../../..".failed:
			return

		if event.is_action_pressed("ui_up"):
			keyPressed = keys.up
			if egg_list.size() < easter_egg.size():
				egg_list.append(keyPressed)
			checkKeys = false
			_process_instruction(keyPressed)
			awaitingInputs = true
			flash_colors(Labels.find(label), keyPressed)

		elif event.is_action_pressed("ui_down"):
			keyPressed = keys.down
			if egg_list.size() < easter_egg.size():
				egg_list.append(keyPressed)
			checkKeys = false
			_process_instruction(keyPressed)
			awaitingInputs = true
			flash_colors(Labels.find(label), keyPressed)

		elif event.is_action_pressed("ui_left"):
			keyPressed = keys.left
			if egg_list.size() < easter_egg.size():
				egg_list.append(keyPressed)
			checkKeys = false
			_process_instruction(keyPressed)
			awaitingInputs = true
			flash_colors(Labels.find(label), keyPressed)
		
		elif event.is_action_pressed("ui_right"):
			keyPressed = keys.right
			if egg_list.size() < easter_egg.size():
				egg_list.append(keyPressed)
			checkKeys = false
			_process_instruction(keyPressed)
			awaitingInputs = true
			flash_colors(Labels.find(label), keyPressed)
		


func check_keys(keyShown, keyClicked):
	if keyShown == keyClicked:
		return true
	else:
		return false
			
func flash_colors(keyShown, keyClicked):
	var check = check_keys(keyShown, keyClicked)
	if check == true:
		label.modulate = Color.GREEN
		score += 2
	else:
		label.modulate = Color.RED
		score -= 1
		#$"../../..".strikes += 1
	#print(score)
	
func hideLabels():
	$Up.hide()
	$Down.hide()
	$Left.hide()
	$Right.hide()

func _on_but_pressed(index : int) -> void:
	if index == 0:
		if !$"../../..".failed:
			print("Start Pressed")
			$StartButton.hide()
			$StartButton.disabled = true
			GameStart = true
			timer.start()
			_startGame()
	if index == 1:
		if !$"../../..".failed:
			setup_fix()
			$StartButton.hide()
			$StartButton.disabled = true
			GameStart = true
			timer.start()
			_startGame()

func win():
	checkKeys = false
	completed = true
	$EndScreen.text = "TEST COMPLETE"
	$EndScreen.modulate = Color.GREEN
	$EndScreen.show()
	await get_tree().create_timer(0.5).timeout
	hideLabels()
	
func lose():
	$EndScreen.text = "TEST FAILED"
	$EndScreen.modulate = Color.RED
	$EndScreen.show()
	await get_tree().create_timer(0.5).timeout
	$Score.text = "Score: " + str(score)
	$Score.show()
	if GameStart == true:
		$"../../..".strikes += 1
		GameStart = false
	key_list.clear()
	egg_list.clear()
	basket_filled = false
	$RestartButton3D.show()


#func _on_restart_button_pressed() -> void:
#	_ready()
#	$StartButton.hide()
#	$StartButton.disabled = true
#	GameStart = true
#	timer.start()
#	_startGame()

func _on_but_released(_index : int):
	pass
	
#func _on_red_wire_button_pressed() -> void:
#	get_tree().change_scene_to_file("res://scenes/menus/practice_menu.tscn")
