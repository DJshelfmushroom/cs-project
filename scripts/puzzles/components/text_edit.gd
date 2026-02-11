extends Node3D

@onready var label: Label3D = $TextEdit1

var text: String = ""
var max_length: int = 16
var caret_visible: bool = true
var caret_timer: float = 0.0
var caret_blink_speed: float = 0.5
var blinker = "|"
var disabled = true

func _ready():
	update_label()

func _process(delta):
	caret_timer += delta
	if caret_timer >= caret_blink_speed:
		caret_timer = 0.0
		caret_visible = !caret_visible
		update_label()

func _input(event):
	if event is InputEventKey and event.pressed and !disabled:
		
		if event.keycode == KEY_BACKSPACE:
			if text.length() > 0:
				text = text.substr(0, text.length() - 1)
		
		elif event.keycode == KEY_ENTER:
			text += "\u200B"
		
		elif event.keycode == KEY_SPACE:
			text += " "
		
		elif event.unicode >= 32:
			if text.length() < max_length:
				text += char(event.unicode)
		
		update_label()

func update_label():
	var display_text = text
	
	if caret_visible:
		display_text += blinker
	
	label.text = display_text
