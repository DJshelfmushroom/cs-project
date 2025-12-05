extends Control

var GameStart = false
@onready var Labels = [$Up, $Down, $Left, $Right]
var processinstruction = null
var checkKeys = false
var awaitingInputs = false
var keyPressed = null

func _ready():
	$StartButton.show()
	hideLabels()
		
func _process(_delta: float):
	if awaitingInputs == true:
		if processinstruction == 0:
			_move_Up()
		if processinstruction == 1:
			_move_Down()
		if processinstruction == 2:
			_move_Left()
		if processinstruction == 3:
			_move_Right()
	
func _move_Up():
	while ($Up.position.y > -96):
		$Up.position.y -= 2
		await get_tree().create_timer(0.1).timeout
	awaitingInputs = false
	
func _move_Down():
	while ($Down.position.y < 1040):
		$Down.position.y += 2
		await get_tree().create_timer(0.1).timeout
	awaitingInputs = false
				
func _move_Left():
	while ($Left.position.x > -214):
		$Left.position.x -= 2
		await get_tree().create_timer(0.1).timeout
	awaitingInputs = false
				
func _move_Right():
	while ($Right.position.x < 1930):
		$Right.position.x += 2
		await get_tree().create_timer(0.1).timeout
	awaitingInputs = false
				
func _process_instruction(key):
	processinstruction = key

func _startGame():
	if (GameStart == true):
		var label = Labels.pick_random()
		label.show()
		checkKeys = true
		#var key = _input()
		_process_instruction(keyPressed)
		awaitingInputs = true
		
#func read_keys():
#	if Input.is_key_pressed(KEY_UP):
#		if checkKeys == true:
#			keyPressed = 0
#			checkKeys = false
#	if Input.is_key_pressed(KEY_DOWN):
#		if checkKeys == true:
#			keyPressed = 1
#			checkKeys = false
#	if Input.is_key_pressed(KEY_LEFT):
#		if checkKeys == true:
#			keyPressed = 2
#			checkKeys = false
#	if Input.is_key_pressed(KEY_RIGHT):
#		if checkKeys == true:
#			keyPressed = 3
#			checkKeys = false
#	return keyPressed

func _input(event):
	if checkKeys == false:
		return

	if event.is_action_pressed("ui_up"):
		keyPressed = 0
		checkKeys = false

	elif event.is_action_pressed("ui_down"):
		keyPressed = 1
		checkKeys = false

	elif event.is_action_pressed("ui_left"):
		keyPressed = 2
		checkKeys = false

	elif event.is_action_pressed("ui_right"):
		keyPressed = 3
		checkKeys = false

func check_keys(keyShown, keyClicked):
	if keyShown == keyClicked:
		return true
	else:
		return false
			
#func flash_colors(keyShown, keyClicked):
	#var check = check_Keys(keyShown, keyClicked)
	#if check == true:
	#	print("yes")	
	
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
