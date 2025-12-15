extends Control

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

func _ready():
	$StartButton.show()
	hideLabels()
	reset_labels()
	set_label_Size()
	place_labels()
	score = 0
	
	
func set_label_Size():
	for x in Labels:
		x.size = Vector2(300, 260)
	
func _process(_delta: float):
	if awaitingInputs:
		if processinstruction == keys.up:
			
			if (label.position.y > -120):
				label.position.y -= 8
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()
			
		elif processinstruction == keys.down:
			
			if (label.position.y < 1040):
				label.position.y += 8
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()

		elif processinstruction == keys.left:
			
			if (label.position.x > -214):
				label.position.x -= 10
			else:
				processinstruction = null
				awaitingInputs = false
				_startGame()			
				
		elif processinstruction == keys.right:
			
			if (label.position.x < 1930):
				label.position.x += 10
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
	if (GameStart == true && score < 16):
		label = Labels.pick_random()
		label.show()
		checkKeys = true
	if (score >= 16):
		win()
		
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
	print(score)
	
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

func win():
	print("You Won!")
