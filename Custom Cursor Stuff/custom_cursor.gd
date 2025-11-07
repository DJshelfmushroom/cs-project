extends Node2D

# Load the custom images for the mouse cursor.
var arrow = load("res://RedWire_Cursor.png")
var hand = load("res://RedWire_Hand.png")


func _ready():
	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(hand, Input.CURSOR_POINTING_HAND)
