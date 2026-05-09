extends Node3D

var id = 8

var circle_scene = preload("res://scenes/components/colors_button_3d.tscn")
var square_scene = preload("res://scenes/components/colors_button_3d_2.tscn")
var triangle_scene = preload("res://scenes/components/colors_button_3d_3.tscn")
var buttons = []
var combo = []
var pressed = []
var completed = false
var shapes = ["circle", "square", "triangle"]

# Positions (top-left, top-right, bottom-right, bottom-left)
var positions = [
	Vector3(-0.18,0.18,0),
	Vector3(0.18,0.18,0),
	Vector3(0.18,-0.18,0),
	Vector3(-0.18,-0.18,0)
]

# Rainbow order (ROYGBP)
var rainbow = [
	Color.RED,
	Color.DARK_ORANGE,
	Color.YELLOW,
	Color.GREEN,
	Color.BLUE,
	Color.PURPLE
]


func _ready():
	buttons.clear()

	var available_colors = [
		Color.RED,
		Color.DARK_ORANGE,
		Color.YELLOW,
		Color.GREEN,
		Color.BLUE,
		Color.PURPLE
	]

	for i in range(4):
		var shape = shapes[randi_range(0, shapes.size() - 1)]

		var scene
		match shape:
			"circle": scene = circle_scene
			"square": scene = square_scene
			"triangle": scene = triangle_scene

		var b = scene.instantiate()

		b.num = i
		b.position = positions[i]
		b.shape = shape

		# pick unique color
		var c_index = randi_range(0, available_colors.size() - 1)
		var color = available_colors[c_index]
		available_colors.remove_at(c_index)

		add_child(b)

		b.set_color(color)

		buttons.append(b)

	generate_combo()


# ========================
# COMBO GENERATION
# ========================
func generate_combo():
	combo.clear()

	var first = get_first_button()
	combo.append(first)

	var second = get_second_button(first)
	combo.append(second)

	var third = get_third_button(second)
	combo.append(third)

	var seq = get_final_sequence()
	combo += seq


# ========================
# FIRST BUTTON
# ========================
func get_first_button():
	var sorted = buttons.duplicate()

	sorted.sort_custom(func(a, b):
		return rainbow.find(a.color) < rainbow.find(b.color)
	)

	var earliest = sorted[0]

	if earliest.shape == "circle":
		return sorted[-1].num
	else:
		return earliest.num


# ========================
# SECOND BUTTON
# ========================
func get_second_button(prev):
	var prev_button = buttons[prev]

	# count same shape
	var same_shape = []
	for b in buttons:
		if b.shape == prev_button.shape and b.num != prev:
			same_shape.append(b)

	if same_shape.size() == 1:
		return same_shape[0].num

	# otherwise rules
	match prev_button.shape:
		"circle":
			return (prev + 1) % 4 # clockwise

		"square":
			return (prev - 1 + 4) % 4 # counterclockwise

		"triangle":
			return (prev + 2) % 4 # diagonal

	return 0


# ========================
# THIRD BUTTON
# ========================
func get_third_button(prev):
	var b = buttons[prev]
	var color = b.color

	var circle_count = count_shape("circle")
	var square_count = count_shape("square")
	var triangle_count = count_shape("triangle")

	# helper positions
	var TL = 0
	var TR = 1
	var BR = 2
	var BL = 3

	if color == Color.RED:
		if circle_count == 1:
			return find_shape("circle")
		return BL

	elif color == Color.DARK_ORANGE: # dark orange
		if square_count == 1:
			return find_shape("square")
		return TL

	elif color == Color.YELLOW:
		if triangle_count == 1:
			return find_shape("triangle")
		return TR

	elif color == Color.GREEN:
		return BR

	elif color == Color.BLUE:
		return BL

	else:
		return TL


# ========================
# FINAL 4 BUTTON SEQUENCE
# ========================
func get_final_sequence():
	var circle_count = count_shape("circle")
	var square_count = count_shape("square")
	var triangle_count = count_shape("triangle")

	var TL = 0
	var TR = 1
	var BR = 2
	var BL = 3

	var seq = []

	# check dominance
	if circle_count > square_count and circle_count > triangle_count:
		# clockwise
		seq = [TL, TR, BR, BL]

	elif square_count > circle_count and square_count > triangle_count:
		# counterclockwise
		seq = [TL, BL, BR, TR]

	elif triangle_count > circle_count and triangle_count > square_count:
		# X pattern
		seq = [TL, BR, TR, BL]

	else:
		# tie
		seq = [BR, BR, BR, BR]

	return seq


# ========================
# HELPERS
# ========================
func count_shape(shape):
	var count = 0
	for b in buttons:
		if b.shape == shape:
			count += 1
	return count


func find_shape(shape):
	for b in buttons:
		if b.shape == shape:
			return b.num
	return 0


# ========================
# GAMEPLAY LOOP
# ========================
func _process(_delta):
	if combo == pressed:
		completed = true
		for b in buttons:
			b.set_color(Color.GREEN)
			b.disabled = true

	if pressed.size() >= combo.size() and combo != pressed:
		#$"../../..".strikes += 1
		pressed.clear()
		var prevcolors = []
		for b in buttons:
			prevcolors.append(b.color)
			b.set_color(Color.RED)
			b.disabled = true
		await get_tree().create_timer(1.0).timeout
		for b in range(buttons.size()):
			buttons[b].set_color(prevcolors[b])
			buttons[b].disabled = false


func _on_but_pressed(num):
	if !completed: #and !$"../../..".failed:
		pressed.append(num)
	
func _on_but_released(_num : int):
	pass
