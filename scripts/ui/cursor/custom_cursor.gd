extends Node2D

# Load the custom images for the mouse cursor.
var arrow = load("res://assets/cursor/RedWire_Cursor.png")
var hand = load("res://assets/cursor/RedWire_Hand.png")
var cursor_color = "red"


func _ready():
	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(hand, Input.CURSOR_POINTING_HAND)
