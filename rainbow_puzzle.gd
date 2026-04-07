extends Node3D

var completed = false
var started = false
var colorsFlashing = false
var Button1Color = null
var Button2Color = null

func _ready():
	started = false
	$Button3D.num = 1
	$Button3D2.num = 2
	Button1Color = randi_range(0, 5)
	Button2Color = randi_range(0, 5)
	if Button2Color == Button1Color:
		while Button2Color == Button1Color:
			Button2Color = randi_range(0, 5)
	
func flash_Button1():
	print(Button1Color)
	if Button1Color == 0:
		$Button3D.set_color(Color.RED)
	if Button1Color == 1:
		$Button3D.set_color(Color.ORANGE)	
	if Button1Color == 2:
		$Button3D.set_color(Color.YELLOW)	
	if Button1Color == 3:
		$Button3D.set_color(Color.GREEN)	
	if Button1Color == 4:
		$Button3D.set_color(Color.BLUE)	
	if Button1Color == 5:
		$Button3D.set_color(Color.PURPLE)

func flash_Button2():
	if Button2Color == 0:
		$Button3D2.set_color(Color.RED)
	if Button2Color == 1:
		$Button3D2.set_color(Color.ORANGE)	
	if Button2Color == 2:
		$Button3D2.set_color(Color.YELLOW)	
	if Button2Color == 3:
		$Button3D2.set_color(Color.GREEN)	
	if Button2Color == 4:
		$Button3D2.set_color(Color.BLUE)	
	if Button2Color == 5:
		$Button3D2.set_color(Color.PURPLE)
	
#func reset_button_color():
	
func _on_but_pressed(num : int) -> void:
	if num == 1:
		if started == false:
			started = true
			flash_Button1()
			#await get_tree().create_timer(0.4).timeout
		
func _on_but_released(_num : int):
	pass
