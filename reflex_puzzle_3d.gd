extends Node3D

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
var score = null
@onready var timer = $Timer
#@onready var screen_size = get_viewport().get_visible_rect()
var completed = false
var practice = true

func set_start_button():
	$StartButton.set_text("START")
	$StartButton/button/Label3D.modulate = Color.WHITE
	$StartButton/button/Label3D.font_size = 220
	$StartButton/button/Label3D.pixel_size = 0.00025
	$StartButton.num = 0
	
#func set_restart_button():
	#$RestartButton3D.set_text("Restart?")
	#$RestartButton3D/button/Label3D.modulate = Color.WHITE
	#$RestartButton3D/button/Label3D.font_size = 220
	#$RestartButton3D/button/Label3D.pixel_size = 0.00025
	#$RestartButton3D.num = 1

func _ready():
	set_start_button()
	#set_restart_button()
	$EndScreen.hide()
	$Score.hide()
	$RestartButton3D.hide()
	$Time.hide()
	$StartButton.show()
	hideLabels()
	reset_labels()
	#set_label_Size()
	place_labels()
	#prepare_timer()
	score = 0
	$Screen3D.position = Vector3(-0.117, -0.117, -0.001)
	$Screen3D.set_size(4,3)
	
	
	
#func set_label_Size():
#	for x in Labels:
#		x.size = Vector2(300, 260)
	
#func prepare_timer():
	#timer.wait_time = 13
	#timer.one_shot = true
	
func _process(_delta: float):
	#if (completed && practice):
	#	$RedWireButton.visible = true
		
	
	#if (time_left() >= 0):
		#if (time_left() >= 10):
			#$Time.text = str(time_left())
		#if (time_left() < 10):
			#$Time.text = "0" + str(time_left())
	if awaitingInputs:
		if processinstruction == keys.up:
			
			if (label_on_screen(label) == true):
				label.position.y += 0.015
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()
			
		elif processinstruction == keys.down:
			
			if (label_on_screen(label) == true):
				label.position.y -= 0.015
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()

		elif processinstruction == keys.left:
			
			if (label_on_screen(label) == true):
				label.position.x -= 0.02
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()			
				
		elif processinstruction == keys.right:
			
			if (label_on_screen(label) == true):
				label.position.x += 0.02
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()
	if score >= 20:
		win()	
				
func _process_instruction(key):
	processinstruction = key

func place_labels():
	for x in Labels:
		x.position = Vector3(0,0, 0)

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
	
func _startGame():
	hideLabels()
	reset_labels()
	place_labels()
	begin()
	#$Time.show()
	if GameStart and !completed:
		label = Labels.pick_random()
		label.show()
		checkKeys = true
	#if (time_left() <= 0):
		#hideLabels()
		#if (score >= 16):
			#win()
		#else:
			#lose()

func _unhandled_input(event):
		if !checkKeys or completed or $"../../..".failed:
			return

		if event.is_action_pressed("ui_up"):
			keyPressed = keys.up
			checkKeys = false
			_process_instruction(keyPressed)
			awaitingInputs = true
			flash_colors(Labels.find(label), keyPressed)

		elif event.is_action_pressed("ui_down"):
			keyPressed = keys.down
			checkKeys = false
			_process_instruction(keyPressed)
			awaitingInputs = true
			flash_colors(Labels.find(label), keyPressed)

		elif event.is_action_pressed("ui_left"):
			keyPressed = keys.left
			checkKeys = false
			_process_instruction(keyPressed)
			awaitingInputs = true
			flash_colors(Labels.find(label), keyPressed)
		
		elif event.is_action_pressed("ui_right"):
			keyPressed = keys.right
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
		$"../../..".strikes += 1
	#print(score)
	
func hideLabels():
	$Up.hide()
	$Down.hide()
	$Left.hide()
	$Right.hide()

func _on_but_pressed(num : int) -> void:
	if num == 0:
		if !$"../../..".failed:
			$StartButton.hide()
			$StartButton.disabled = true
			GameStart = true
			timer.start()
			_startGame()
	if num == 1:
		if !$"../../..".failed:
			_ready()
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
	
	#$Score.text = "Score: " + str(score)
	#$Score.show()
	
#func lose():
	#$EndScreen.text = "You Lost"
	#$EndScreen.show()
	#$"../../..".strikes += 1
	#await get_tree().create_timer(0.5).timeout
	#$Score.text = "Score: " + str(score)
	#$Score.show()
	#$RestartButton3D.show()


#func _on_restart_button_pressed() -> void:
#	_ready()
#	$StartButton.hide()
#	$StartButton.disabled = true
#	GameStart = true
#	timer.start()
#	_startGame()

func _on_but_released(_num : int):
	pass
	
#func _on_red_wire_button_pressed() -> void:
#	get_tree().change_scene_to_file("res://scenes/menus/practice_menu.tscn")
