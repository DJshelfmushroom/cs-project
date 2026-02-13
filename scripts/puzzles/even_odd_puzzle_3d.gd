extends Node3D

var completed = false
var buttons = []
var combo = []
var colors = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW]
var pressed = []

func _ready() -> void:
	for x in range(3):
		buttons.append(get_node("CB3D" + str(x)))
		get_node("CB3D" + str(x)).num = x
	var gen = RandomNumberGenerator.new()
	for button in buttons:
		var rand = gen.randi_range(0,colors.size() - 1)
		button.set_color(colors[rand])
		colors.remove_at(rand)
		
		
	if colors[0] != Color.RED:
		combo.append(0)
	else:
		for button in buttons:
			if button.color == Color.BLUE:
				combo.append(button.num)
	
	
	if buttons[combo[0]].color == Color.RED:
		if colors[0] != Color.YELLOW:
			for button in buttons:
				if button.color == Color.YELLOW:
					combo.append(button.num)
		else:
			for button in buttons:
				if button.color == Color.BLUE:
					combo.append(button.num)
	elif buttons[combo[0]].color == Color.BLUE:
		if colors[0] != Color.GREEN:
			for button in buttons:
				if button.color == Color.GREEN:
					combo.append(button.num)
		else:
			for button in buttons:
				if button.color == Color.RED:
					combo.append(button.num)
	elif buttons[combo[0]].color == Color.GREEN:
		if colors[0] != Color.BLUE:
			for button in buttons:
				if button.color == Color.BLUE:
					combo.append(button.num)
		else:
			for button in buttons:
				if button.color == Color.YELLOW:
					combo.append(button.num)
	elif buttons[combo[0]].color == Color.YELLOW:
		if colors[0] != Color.RED:
			for button in buttons:
				if button.color == Color.RED:
					combo.append(button.num)
		else:
			for button in buttons:
				if button.color == Color.GREEN:
					combo.append(button.num)
		
	
	if colors[0] == Color.RED:
		for button in buttons:
			if button.color == Color.BLUE:
				combo.append(button.num)
	elif colors[0] == Color.BLUE:
		for button in buttons:
			if button.color == Color.GREEN:
				combo.append(button.num)
	elif colors[0] == Color.GREEN:
		for button in buttons:
			if button.color == Color.YELLOW:
				combo.append(button.num)
	elif colors[0] == Color.YELLOW:
		for button in buttons:
			if button.color == Color.RED:
				combo.append(button.num)
				
				
func _process(_delta: float) -> void:
	if combo == pressed:
		completed = true
		for button in buttons:
			button.set_color(Color.GREEN)
	if pressed.size() >= 3 && combo != pressed:
		$"../../..".strikes += 1
		pressed = []
		var c0 = buttons[0].color
		var c1 = buttons[1].color
		var c2 = buttons[2].color
		for button in buttons:
			button.set_color(Color.RED)
		await get_tree().create_timer(1.0).timeout
		buttons[0].set_color(c0)
		buttons[1].set_color(c1)
		buttons[2].set_color(c2)
				
				
				
func _on_but_pressed(num : int):
	if pressed.size() < 3 && !completed && !$"../../..".failed:
		pressed.append(num)
	
func _on_but_released(_num : int):
	pass
