extends Node3D

@onready var label := $TextEdit1
var text_buffer := ""
var caret_pos := 0
var caret_visible := true

func _ready():
	# Caret blink
	var t := Timer.new()
	t.wait_time = 0.5
	t.autostart = true
	t.one_shot = false
	t.timeout.connect(_toggle_caret)
	add_child(t)
	_refresh()

func _input(event):
	if event is InputEventKey and event.pressed:
		
		if event.keycode == KEY_BACKSPACE and caret_pos > 0:
			text_buffer = text_buffer.substr(0, caret_pos - 1) + text_buffer.substr(caret_pos)
			caret_pos -= 1
			_refresh()
			return

		if event.unicode != 0 && text_buffer.length() < 1:
			_insert(String.chr(event.unicode))

func _insert(char: String):
	text_buffer = text_buffer.substr(0, caret_pos) + char + text_buffer.substr(caret_pos)
	caret_pos += char.length()
	_refresh()

func _toggle_caret():
	caret_visible = !caret_visible
	_refresh()

func _refresh():
	if caret_visible:
		label.mesh.text = text_buffer.substr(0, caret_pos) + "|" + text_buffer.substr(caret_pos)
	else:
		label.mesh.text = text_buffer
