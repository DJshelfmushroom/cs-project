extends Node3D

var id = 13

var completed = false
var allpositions = []
var positions = []
var buttons = []
var button_scene = preload("res://scenes/components/shift_button_3d.tscn")
var colors = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW, Color.WEB_PURPLE, Color.DARK_ORANGE, Color.HOT_PINK]

func _ready() -> void:
	$Screen3D.set_size(1.6,1.1)
	$Screen3D.position = Vector3(-0.475,-0.53, 0.001)
	
	for y in range(-1,2):
		for x in range(-2,3):
			positions.append(Vector3(x / 4.0, y / 4.0, 0.002))
			allpositions.append(Vector3(x / 4.0, y / 4.0, 0.002))
		
	for b in range(14):
		var buttoninst = button_scene.instantiate()
		var rand = randi_range(0,positions.size() - 1)
		buttoninst.position = positions[rand]
		for p in range(allpositions.size()):
			if buttoninst.position == allpositions[p]:
				buttoninst.pos = p
		positions.remove_at(rand)
		@warning_ignore("integer_division")
		buttoninst.set_color(colors[b / 2])
		buttoninst.num = b
		buttons.append(buttoninst)
		add_child(buttoninst)
		
func _process(_delta: float) -> void:
	var win = true
	var pos1
	var pos2
	for i in range(0,14,2):
		for x in range(allpositions.size()):
			if allpositions[x] == buttons[i].position:
				pos1 = x
		for x in range(allpositions.size()):
			if allpositions[x] == buttons[i+1].position:
				pos2 = x
		if !is_adjacent(pos1,pos2):
			win = false
	if win:
		completed = true
		$Label3D.modulate = Color.GREEN
		for b in buttons:
			b.disabled = true
	
	
		
func is_adjacent(a, b):
	var width = 5
	var diff = abs(a - b)

	return (diff == 1 and a / width == b / width) or diff == width

func _on_but_pressed(num : int):
	var pressed_button = null
	for b in buttons:
		if b.num == num:
			pressed_button = b
			break

	if pressed_button == null:
		return

	var emptypos = -1
	for p in range(allpositions.size()):
		var occupied = false
		for b in buttons:
			if b.pos == p:
				occupied = true
				break
		if not occupied:
			emptypos = p
			break
			
	if is_adjacent(emptypos, pressed_button.pos):
		pressed_button.pos = emptypos
		pressed_button.position = allpositions[emptypos]
	
func _on_but_released(_num : int):
	pass
