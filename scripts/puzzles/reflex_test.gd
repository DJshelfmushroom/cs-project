extends Control

@onready var original_minigame = preload("res://scenes/puzzles/simon_says.tscn")
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
@onready var screen_size = get_viewport().get_visible_rect()
var completed = false
var practice = true

func _ready():
	$EndScreen.hide()
	$Score.hide()
	$RestartButton.hide()
	$Time.hide()
	$StartButton.show()
	hideLabels()
	reset_labels()
	set_label_Size()
	place_labels()
	prepare_timer()
	score = 0
	
	
func set_label_Size():
	for x in Labels:
		x.size = Vector2(300, 260)
	
func prepare_timer():
	timer.wait_time = 13
	timer.one_shot = true
	
func _process(_delta: float):
	if (completed && practice):
		$RedWireButton.visible = true
		
	
	if (time_left() >= 0):
		if (time_left() >= 10):
			$Time.text = str(time_left())
		if (time_left() < 10):
			$Time.text = "0" + str(time_left())
	if awaitingInputs:
		if processinstruction == keys.up:
			
			if (label_on_screen(label) == true):
				label.position.y -= 8
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()
			
		elif processinstruction == keys.down:
			
			if (label_on_screen(label) == true):
				label.position.y += 8
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()

		elif processinstruction == keys.left:
			
			if (label_on_screen(label) == true):
				label.position.x -= 10.5
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()			
				
		elif processinstruction == keys.right:
			
			if (label_on_screen(label) == true):
				label.position.x += 10.5
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()
						
				
func _process_instruction(key):
	processinstruction = key

func place_labels():
	for x in Labels:
		x.position = Vector2(800,380)

func reset_labels():
	for x in Labels:
		x.add_theme_color_override("font_color", Color.WHITE)

func time_left():
	return int(timer.get_time_left())

func label_on_screen(word):
	var rect = word.get_global_rect()
	return screen_size.intersects(rect)

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
	$Time.show()
	if (GameStart == true && time_left() > 0):
		label = Labels.pick_random()
		label.show()
		checkKeys = true
	if (time_left() <= 0):
		hideLabels()
		if (score >= 16):
			win()
		else:
			lose()

func _unhandled_input(event):
	if checkKeys == false:
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
		label.add_theme_color_override("font_color", Color.GREEN)
		score += 2
	else:
		label.add_theme_color_override("font_color", Color.RED)
		score -= 1
	#print(score)
	
func hideLabels():
	$Up.hide()
	$Down.hide()
	$Left.hide()
	$Right.hide()

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$StartButton.disabled = true
	GameStart = true
	timer.start()
	_startGame()

func win():
	$EndScreen.text = "You Won!"
	$EndScreen.show()
	await get_tree().create_timer(0.5).timeout
	$Score.text = "Score: " + str(score)
	$Score.show()
	completed = true
func lose():
	$EndScreen.text = "You Lost"
	$EndScreen.show()
	await get_tree().create_timer(0.5).timeout
	$Score.text = "Score: " + str(score)
	$Score.show()
	$RestartButton.show()


func _on_restart_button_pressed() -> void:
	_ready()
	$StartButton.hide()
	$StartButton.disabled = true
	GameStart = true
	timer.start()
	_startGame()

func _on_red_wire_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/practice_menu.tscn")
