extends Control

var red_arrow = load("res://assets/cursor/RedWire_Cursor.png")
var red_hand = load("res://assets/cursor/RedWire_Hand.png")

var green_arrow = load("res://assets/cursor/Green_RedWire_Cursor.png")
var green_hand = load("res://assets/cursor/Green_RedWire_Cursor.png")

var mouse_cursor = null


func _ready() -> void:
	place_set()
	
func check_mouse_cursor():
	return $MainMenu/CustomCursor.cursor_color

func place_set():
	if (check_mouse_cursor() == "red"):
		$Set.position = Vector2($Red_Mouse.position.x + 115, $Red_Mouse.position.y + 140)
	if (check_mouse_cursor() == "green"):
		$Set.position = Vector2($Green_Mouse.position.x + 115, $Green_Mouse.position.y + 140)
		



func _on_red_mouse_pressed() -> void:
	Input.set_custom_mouse_cursor(red_arrow, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(red_hand, Input.CURSOR_POINTING_HAND)
	place_set()
	
func _on_green_mouse_pressed() -> void:
	Input.set_custom_mouse_cursor(green_arrow, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(green_hand, Input.CURSOR_POINTING_HAND)
	place_set()
