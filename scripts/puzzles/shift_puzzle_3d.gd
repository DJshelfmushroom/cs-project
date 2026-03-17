extends Node3D

var id = 13

var completed = false
var allpositions = []
var allpositions2 = []
var positions = []
var positions2 = []
var buttons = []
var buttons2 = []
var button_scene = preload("res://scenes/components/shift_button_3d.tscn")
var colors = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW]

func _ready() -> void:
	$Screen3D.set_size(2,1.2)
	$Screen3D.position = Vector3(-0.475,-0.5, 0.001)
	
	for y in range(-1,2):
		for x in range(-3,0):
			positions.append(Vector3(x / 4.0, y / 4.0, 0.002))
			allpositions.append(Vector3(x / 4.0, y / 4.0, 0.002))
	for y in range(-1,2):
		for x in range(1,4):
			positions2.append(Vector3(x / 4.0, y / 4.0, 0.002))
			allpositions2.append(Vector3(x / 4.0, y / 4.0, 0.002))
	
	for b in range(8):
		var buttoninst = button_scene.instantiate()
		var rand = randi_range(0,positions2.size() - 1)
		buttoninst.position = positions2[rand]
		for p in range(allpositions2.size()):
			if buttoninst.position == allpositions2[p]:
				buttoninst.pos = p
		positions2.remove_at(rand)
		buttoninst.set_color(colors[b / 2])
		buttoninst.num = b
		buttoninst.disabled = true
		buttons2.append(buttoninst)
		add_child(buttoninst)
		
	for b in range(8):
		var buttoninst = button_scene.instantiate()
		var rand = randi_range(0,positions.size() - 1)
		buttoninst.position = positions[rand]
		for p in range(allpositions.size()):
			if buttoninst.position == allpositions[p]:
				buttoninst.pos = p
		positions.remove_at(rand)
		buttoninst.set_color(colors[b / 2])
		buttoninst.num = b
		buttons.append(buttoninst)
		add_child(buttoninst)
		
func _process(_delta: float) -> void:
	var win = true
	var but1 = null
	var but2 = null
	for x in range(allpositions.size()):
		for b in buttons:
			if b.position == allpositions[x]:
				but1 = b
		for b in buttons2:
			if b.position == allpositions2[x]:
				but2 = b
		if but1 == null and but2 == null:
			pass
		elif but1 == null or but2 == null:
			win = false
		elif but1.get_color() != but2.get_color():
			win = false
		but1 = null
		but2 = null
	if win:
		completed = true
		$Label3D.modulate = Color.GREEN
		for b in buttons:
			b.disabled = true
	
	
		
func is_adjacent(a, b):
	var diff = abs(a - b)

	if diff == 1 and a / 3 == b / 3:
		return true

	if diff == 3:
		return true

	return false

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
