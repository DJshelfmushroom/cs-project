extends Node2D

# Load the custom images for the mouse cursor.
var this_arrow = null
var this_hand = null
var cursor_color = "red"


func set_mouse_cursor(arrow, hand, color):
	this_arrow = arrow
	this_hand = hand
	Input.set_custom_mouse_cursor(this_arrow, Input.CURSOR_ARROW, Vector2(12,2))
	Input.set_custom_mouse_cursor(this_hand, Input.CURSOR_POINTING_HAND, Vector2(12,2))
	cursor_color = color
	#Utils.LogGD("Mouse cursor changed", self) # if this is unwelcome you can change it


func get_mouse_arrow():
	return this_arrow
func get_mouse_hand():
	return this_hand
func get_mouse_color():
	return cursor_color
