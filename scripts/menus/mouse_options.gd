extends Control

var red_arrow = load("res://assets/cursor/RedWire_Cursor.png")
var red_hand = load("res://assets/cursor/RedWire_Hand.png")

var green_arrow = load("res://assets/cursor/Green_RedWire_Cursor.png")
var green_hand = load("res://assets/cursor/Green_RedWire_Hand.png")

var black_arrow = load("res://assets/cursor/Black_RedWire_Cursor.png")
var black_hand = load("res://assets/cursor/Black_RedWire_Hand.png")

var silver_arrow = load("res://assets/cursor/Silver_RedWire_Cursor.png")
var silver_hand = load("res://assets/cursor/Silver_RedWire_Hand.png")

var mouse_cursor = null


func _ready():
	place_set()
	prepare_buttons()
	
	
func check_mouse_cursor():
	return SaveManager.color

func prepare_buttons():
	if (SaveManager.level < 3):
		set_green_to_base()
	if (SaveManager.level < 8):
		set_black_to_base()

func place_set():
	if (check_mouse_cursor() == "red"):
		$Set.position = Vector2($Red_Mouse.position.x + 85, $Red_Mouse.position.y + 140)
		$Set.show()
	elif (check_mouse_cursor() == "green"):
		$Set.position = Vector2($Green_Mouse.position.x + 85, $Green_Mouse.position.y + 140)
		$Set.show()
	elif (check_mouse_cursor() == "black"):
		$Set.position = Vector2($Black_Mouse.position.x + 85, $Black_Mouse.position.y + 140)
		$Set.show()
	elif (check_mouse_cursor() == "silver"):
		$Set.position = Vector2($Silver_Mouse.position.x + 85, $Silver_Mouse.position.y + 140)
		$Set.show()
	else:
		$Set.hide()
	

func set_green_to_base():
	$Green_Mouse.text = "Unlocks at Level 3"
	$Green_Mouse.disabled = true
func set_black_to_base():
	$Black_Mouse.text = "Unlocks at Level 8"
	$Black_Mouse.disabled = true

func _on_red_mouse_pressed() -> void:
	SaveManager.arrow = red_arrow
	SaveManager.hand  = red_hand
	SaveManager.color = "red"
	
	$CustomCursor.set_mouse_cursor(red_arrow, red_hand, "red")
	place_set()
	SaveManager.save()
	
func _on_green_mouse_pressed() -> void:
	SaveManager.arrow = green_arrow
	SaveManager.hand  = green_hand
	SaveManager.color = "green"
	
	$CustomCursor.set_mouse_cursor(green_arrow, green_hand, "green")
	place_set()
	SaveManager.save()

func _on_black_mouse_pressed() -> void:
	SaveManager.arrow = black_arrow
	SaveManager.hand  = black_hand
	SaveManager.color = "black"
	
	$CustomCursor.set_mouse_cursor(black_arrow, black_hand, "black")
	place_set()
	SaveManager.save()

func _on_silver_mouse_pressed() -> void:
	SaveManager.arrow = silver_arrow
	SaveManager.hand  = silver_hand
	SaveManager.color = "silver"
	
	$CustomCursor.set_mouse_cursor(silver_arrow, silver_hand, "silver")
	place_set()
	SaveManager.save()


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
