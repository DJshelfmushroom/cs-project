extends Node3D

var id = 15

var completed = false
var started = false
var colorsFlashing = false
var Color1 = null
var Color2 = null
var Color3 = null
var colorList = []
var buttonsPressed = []
var longmode = true
var cap = 2

func _ready():
	cap = 2
	if longmode == true:
		cap = 3
	started = false
	$Button3D.num = 1
	$Button3D2.num = 2
	$Button3D.set_text("P")
	$Button3D.text_size(250)
	$Button3D2.set_text("S")
	$Button3D2.text_size(250)
	$Button3D.off()
	$Button3D2.off()
	colorList.clear()
	buttonsPressed.clear()
	Color1 = randi_range(0, 5)
	Color2 = randi_range(0, 5)
	if Color2 == Color1:
		while Color2 == Color1:
			Color2 = randi_range(0, 5)
	colorList.append(Color1)
	colorList.append(Color2)
	if longmode == true:
		longer_setup()
	yes_Press()
	
	
func longer_setup():
	Color3 = randi_range(0, 5)
	if Color3 == Color2 || Color3 == Color1:
		while Color3 == Color2 || Color3 == Color1:
			Color3 = randi_range(0, 5)
	colorList.append(Color3)
	
func flash_Color1():
	if Color1 == 0:
		$Button3D.set_color(Color.RED)
		$Button3D2.set_color(Color.RED)
	elif Color1 == 1:
		$Button3D.set_color(Color.ORANGE)
		$Button3D2.set_color(Color.ORANGE)		
	elif Color1 == 2:
		$Button3D.set_color(Color.YELLOW)	
		$Button3D2.set_color(Color.YELLOW)	
	elif Color1 == 3:
		$Button3D.set_color(Color.GREEN)
		$Button3D2.set_color(Color.GREEN)	
	elif Color1 == 4:
		$Button3D.set_color(Color.BLUE)	
		$Button3D2.set_color(Color.BLUE)
	elif Color1 == 5:
		$Button3D.set_color(Color.PURPLE)
		$Button3D2.set_color(Color.PURPLE)
	await get_tree().create_timer(0.8).timeout
	$Button3D.off()
	$Button3D2.off()
	
		
func flash_Color2():
	if Color2 == 0:
		$Button3D.set_color(Color.RED)
		$Button3D2.set_color(Color.RED)
	elif Color2 == 1:
		$Button3D.set_color(Color.ORANGE)
		$Button3D2.set_color(Color.ORANGE)		
	elif Color2 == 2:
		$Button3D.set_color(Color.YELLOW)	
		$Button3D2.set_color(Color.YELLOW)	
	elif Color2 == 3:
		$Button3D.set_color(Color.GREEN)
		$Button3D2.set_color(Color.GREEN)	
	elif Color2 == 4:
		$Button3D.set_color(Color.BLUE)	
		$Button3D2.set_color(Color.BLUE)
	elif Color2 == 5:
		$Button3D.set_color(Color.PURPLE)
		$Button3D2.set_color(Color.PURPLE)
	await get_tree().create_timer(0.8).timeout
	$Button3D.off()
	$Button3D2.off()
	
	
func flash_Color3():
	if Color3 == 0:
		$Button3D.set_color(Color.RED)
		$Button3D2.set_color(Color.RED)
	elif Color3 == 1:
		$Button3D.set_color(Color.ORANGE)
		$Button3D2.set_color(Color.ORANGE)		
	elif Color3 == 2:
		$Button3D.set_color(Color.YELLOW)	
		$Button3D2.set_color(Color.YELLOW)	
	elif Color3 == 3:
		$Button3D.set_color(Color.GREEN)
		$Button3D2.set_color(Color.GREEN)	
	elif Color3 == 4:
		$Button3D.set_color(Color.BLUE)	
		$Button3D2.set_color(Color.BLUE)
	elif Color3 == 5:
		$Button3D.set_color(Color.PURPLE)
		$Button3D2.set_color(Color.PURPLE)
	await get_tree().create_timer(0.8).timeout
	$Button3D.off()
	$Button3D2.off()
	

func no_Press():
	$Button3D.ignore_hover = true
	$Button3D2.ignore_hover = true
	$Button3D.disabled = true
	$Button3D2.disabled = true
	
func yes_Press():
	$Button3D.ignore_hover = false
	$Button3D2.ignore_hover = false
	$Button3D.disabled = false
	$Button3D2.disabled = false
	
func is_Odd(number):
	if number % 2 == 0:
		return false
	else:
		return true

func check_for_outcome():
	if !is_Odd(colorList[0]) && !is_Odd(colorList[1]): #two primary colors
		if buttonsPressed[0] == 0 && buttonsPressed[1] == 0:
			win()
		else:
			lose()
	elif is_Odd(colorList[0]) && is_Odd(colorList[1]): #two secondary colors
		if buttonsPressed[0] == 1 && buttonsPressed[1] == 1:
			win()
		else:
			lose()
	elif !is_Odd(colorList[0]) && is_Odd(colorList[1]): #primary color, secondary color
		if buttonsPressed[0] == 0 && buttonsPressed[1] == 1:
			win()
		else:
			lose()
	elif is_Odd(colorList[0]) && !is_Odd(colorList[1]): #secondary color, primary color
		if buttonsPressed[0] == 1 && buttonsPressed[1] == 0:
			win()
		else:
			lose()
	
func check_for_outcome_hard():
	if !is_Odd(colorList[0]) && !is_Odd(colorList[1]) && !is_Odd(colorList[2]): #three primary colors
		if buttonsPressed[0] == 0 && buttonsPressed[1] == 0 && buttonsPressed[2] == 0:
			win()
		else:
			lose()
	elif is_Odd(colorList[0]) && is_Odd(colorList[1]) && is_Odd(colorList[2]): #three secondary colors
		if buttonsPressed[0] == 1 && buttonsPressed[1] == 1 && buttonsPressed[2] == 1:
			win()
		else:
			lose()
	elif !is_Odd(colorList[0]) && is_Odd(colorList[1]) && !is_Odd(colorList[2]): #primary color, secondary color, primary color
		if buttonsPressed[0] == 0 && buttonsPressed[1] == 1 && buttonsPressed[2] == 0:
			win()
		else:
			lose()
	elif is_Odd(colorList[0]) && !is_Odd(colorList[1]) && is_Odd(colorList[2]): #secondary color, primary color, secondary color
		if buttonsPressed[0] == 1 && buttonsPressed[1] == 0 && buttonsPressed[2] == 1:
			win()
		else:
			lose()
	elif !is_Odd(colorList[0]) && !is_Odd(colorList[1]) && is_Odd(colorList[2]): #primary color, primary color, secondary color
		if buttonsPressed[0] == 0 && buttonsPressed[1] == 0 && buttonsPressed[2] == 1:
			win()
		else:
			lose()
	elif !is_Odd(colorList[0]) && is_Odd(colorList[1]) && is_Odd(colorList[2]): #primary color, secondary color, secondary color
		if buttonsPressed[0] == 0 && buttonsPressed[1] == 1 && buttonsPressed[2] == 1:
			win()
		else:
			lose()
	elif is_Odd(colorList[0]) && !is_Odd(colorList[1]) && !is_Odd(colorList[2]): #secondary color, primary color, primary color
		if buttonsPressed[0] == 1 && buttonsPressed[1] == 0 && buttonsPressed[2] == 0:
			win()
		else:
			lose()
	elif is_Odd(colorList[0]) && is_Odd(colorList[1]) && !is_Odd(colorList[2]): #secondary color, secondary color, primary color
		if buttonsPressed[0] == 1 && buttonsPressed[1] == 1 && buttonsPressed[2] == 0:
			win()
		else:
			lose()
	

func win():
	$Button3D.set_color(Color.GREEN)
	$Button3D2.set_color(Color.GREEN)
	await get_tree().create_timer(0.2).timeout
	$Button3D.off()
	$Button3D2.off()
	await get_tree().create_timer(0.2).timeout
	$Button3D.set_color(Color.GREEN)
	$Button3D2.set_color(Color.GREEN)
	completed = true
	no_Press()

func lose():
	$Button3D.set_color(Color.RED)
	$Button3D2.set_color(Color.RED)
	await get_tree().create_timer(0.2).timeout
	$Button3D.off()
	$Button3D2.off()
	await get_tree().create_timer(0.2).timeout
	$Button3D.set_color(Color.RED)
	$Button3D2.set_color(Color.RED)
	no_Press()
	$"../../..".strikes += 1
	_ready()

func _on_but_pressed(num : int) -> void:
	if started == false:
		started = true
		no_Press()
		await flash_Color1()
		await flash_Color2()
		if longmode == true:
			await flash_Color3()
		yes_Press()
	else:
		if !$"../../..".failed:
			if num == 1:
				buttonsPressed.append(0)
				if buttonsPressed.size() >= cap:
					no_Press()
					if longmode == true:
						check_for_outcome_hard()
					else:
						check_for_outcome()
			if num == 2:
				buttonsPressed.append(1)
				if buttonsPressed.size() >= cap:
					no_Press()
					if longmode == true:
						check_for_outcome_hard()
					else:
						check_for_outcome()


func _on_but_released(_num : int):
	pass
