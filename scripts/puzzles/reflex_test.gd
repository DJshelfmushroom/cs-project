extends Control

var GameStart = false
@onready var Labels = [$Up, $Down, $Left, $Right]
var label = null
var processinstruction = null
var checkKeys = false
var awaitingInputs = false
var keyPressed = null

func _ready():
	$StartButton.show()
	hideLabels()
	reset_labels()
	place_labels()
		
func _process(_delta: float):
	if awaitingInputs == true:
		if processinstruction == 0:
			_move_Up()
			
		elif processinstruction == 1:
			_move_Down()
			
		elif processinstruction == 2:
			_move_Left()
			
		elif processinstruction == 3:
			_move_Right()
			
		
func _move_Up():
	while (label.position.y > -120):
		label.position.y -= 2
		await get_tree().create_timer(0.1).timeout
	awaitingInputs = false
	_startGame()
	
func _move_Down():
	while (label.position.y < 1040):
		label.position.y += 2
		await get_tree().create_timer(0.1).timeout
	awaitingInputs = false
	_startGame()
				
func _move_Left():
	while (label.position.x > -214):
		label.position.x -= 2
		await get_tree().create_timer(0.1).timeout
	awaitingInputs = false
	_startGame()
				
func _move_Right():
	while (label.position.x < 1930):
		label.position.x += 2
		await get_tree().create_timer(0.1).timeout
	awaitingInputs = false
	_startGame()
				
func _process_instruction(key):
	processinstruction = key

func place_labels():
	for x in Labels:
		x.position = Vector2(842,424)

func reset_labels():
	for x in Labels:
		x.add_theme_color_override("font_color", Color.WHITE)

func begin():
	label = null
	processinstruction = null
	checkKeys = false
	awaitingInputs = false
	keyPressed = null
	hideLabels()
	
func _startGame():
	reset_labels()
	place_labels()
	begin()
	if (GameStart == true):
		label = Labels.pick_random()
		label.show()
		checkKeys = true
		
func _input(event):
	if checkKeys == false:
		return

	if event.is_action_pressed("ui_up"):
		keyPressed = 0
		checkKeys = false
		_process_instruction(keyPressed)
		awaitingInputs = true
		flash_colors(Labels.find(label), keyPressed)

	elif event.is_action_pressed("ui_down"):
		keyPressed = 1
		checkKeys = false
		_process_instruction(keyPressed)
		awaitingInputs = true
		flash_colors(Labels.find(label), keyPressed)

	elif event.is_action_pressed("ui_left"):
		keyPressed = 2
		checkKeys = false
		_process_instruction(keyPressed)
		awaitingInputs = true
		flash_colors(Labels.find(label), keyPressed)
	
	elif event.is_action_pressed("ui_right"):
		keyPressed = 3
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
	else:
		label.add_theme_color_override("font_color", Color.RED)
	
func hideLabels():
	$Up.hide()
	$Down.hide()
	$Left.hide()
	$Right.hide()

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$StartButton.disabled = true
	GameStart = true
	_startGame()
