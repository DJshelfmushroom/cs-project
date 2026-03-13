extends Control

var red_arrow = preload("res://assets/cursor/RedWire_Cursor.png")
var red_hand = preload("res://assets/cursor/RedWire_Hand.png")

var green_arrow = preload("res://assets/cursor/Green_RedWire_Cursor.png")
var green_hand = preload("res://assets/cursor/Green_RedWire_Hand.png")

var black_arrow = preload("res://assets/cursor/Black_RedWire_Cursor.png")
var black_hand = preload("res://assets/cursor/Black_RedWire_Hand.png")

var silver_arrow = preload("res://assets/cursor/Silver_RedWire_Cursor.png")
var silver_hand = preload("res://assets/cursor/Silver_RedWire_Hand.png")

var quick_arrow = preload("res://assets/cursor/Quick_RedWire_Cursor.png")
var quick_hand = preload("res://assets/cursor/Quick_RedWire_Hand.png")

var glitched_arrow = preload("res://assets/cursor/Glitched_RedWire_Cursor.png")
var glitched_hand = preload("res://assets/cursor/Glitched_RedWire_Hand.png")

var mouse_cursor = null


func _ready():
	place_set()
	prepare_buttons()
	
	
func check_mouse_cursor():
	return SaveManager.color

func prepare_buttons():
	if (SaveManager.level < 3):
		set_green_to_base()
	if (SaveManager.level < 6):
		set_black_to_base()
	if (SaveManager.level < 9):
		set_silver_to_base()
	if (!Achievements.check_achievement_completed(3) && !Achievements.check_achievement_completed(4)):
		set_quick_to_base()

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
	elif (check_mouse_cursor() == "quick"):
		$Set.position = Vector2($Quick_Mouse.position.x + 85, $Quick_Mouse.position.y + 140)
		$Set.show()
	elif (check_mouse_cursor() == "glitched"):
		$Set.position = Vector2($Glitched_Mouse.position.x + 85, $Glitched_Mouse.position.y + 140)
		$Set.show()
	else:
		$Set.hide()
	

func set_green_to_base():
	$Green_Mouse.text = "Unlocks at Level 3"
	$Green_Mouse.disabled = true
func set_black_to_base():
	$Black_Mouse.text = "Unlocks at Level 6"
	$Black_Mouse.disabled = true
func set_silver_to_base():
	$Silver_Mouse.text = "Unlocks at Level 9"
	$Silver_Mouse.disabled = true
func set_quick_to_base():
	$Quick_Mouse.text = "Unlocks after completing speedrunner achievements"
	$Quick_Mouse.disabled = true

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

func _on_quick_mouse_pressed() -> void:
	SaveManager.arrow = quick_arrow
	SaveManager.hand  = quick_hand
	SaveManager.color = "quick"
	
	$CustomCursor.set_mouse_cursor(quick_arrow, quick_hand, "quick")
	place_set()
	SaveManager.save()

func _on_glitched_mouse_pressed() -> void:
	SaveManager.arrow = glitched_arrow
	SaveManager.hand  = glitched_hand
	SaveManager.color = "glitched"
	
	$CustomCursor.set_mouse_cursor(glitched_arrow, glitched_hand, "glitched")
	place_set()
	SaveManager.save()
	
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
