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
var completed = false
var longmode = false
var scoreToWin = 20

func set_start_button():
	$StartButton.set_text("START")
	$StartButton/button/Label3D.modulate = Color.WHITE
	$StartButton/button/Label3D.font_size = 220
	$StartButton/button/Label3D.pixel_size = 0.00025
	$StartButton.num = 0
	
func _ready():
	scoreToWin = 20
	if longmode == true:
		scoreToWin = 30
	set_start_button()
	$EndScreen.hide()
	$Score.hide()
	$RestartButton3D.hide()
	$Time.hide()
	$StartButton.show()
	hideLabels()
	reset_labels()
	place_labels()
	score = 0
	$Screen3D.position = Vector3(-0.117, -0.117, 0.001)
	$Screen3D.set_size(4,3)
	
	

	
func _process(_delta: float):
	if awaitingInputs:
		if processinstruction == keys.up:
			
			if (label_on_screen(label) == true):
				label.position.y += 0.015 * _delta * 60
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()
			
		elif processinstruction == keys.down:
			
			if (label_on_screen(label) == true):
				label.position.y -= 0.015 * _delta * 60
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()

		elif processinstruction == keys.left:
			
			if (label_on_screen(label) == true):
				label.position.x -= 0.02 * _delta * 60
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()			
				
		elif processinstruction == keys.right:
			
			if (label_on_screen(label) == true):
				label.position.x += 0.02 * _delta * 60
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()
	if score >= scoreToWin:
		win()	
				
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
	
func _startGame():
	hideLabels()
	reset_labels()
	place_labels()
	begin()
	if GameStart and !completed:
		label = Labels.pick_random()
		label.show()
		checkKeys = true
	
func _unhandled_input(event):
		if !checkKeys or completed: #or $"../../..".failed:
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
		#$"../../..".strikes += 1
	
	
func hideLabels():
	$Up.hide()
	$Down.hide()
	$Left.hide()
	$Right.hide()

func _on_but_pressed(num : int) -> void:
	if num == 0:
		#if !$"../../..".failed:
			$StartButton.hide()
			$StartButton.disabled = true
			GameStart = true
			timer.start()
			_startGame()
	if num == 1:
		#if !$"../../..".failed:
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

	





func _on_but_released(_num : int):
	pass
	
