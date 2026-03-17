extends Node2D

# Load the custom images for the mouse cursor.
var this_arrow = null
var this_hand = null
var cursor_color = "red"

var pressed = false


func set_mouse_cursor(arrow, hand, color):
	this_arrow = arrow
	this_hand = hand
	cursor_color = color
	Input.set_custom_mouse_cursor(this_arrow, Input.CURSOR_ARROW, Vector2(12,2))
	Input.set_custom_mouse_cursor(this_hand, Input.CURSOR_POINTING_HAND, Vector2(12,2))
	
	fix_mouse()
	#Utils.LogGD("Mouse cursor changed", self) # if this is unwelcome you can change it


func fix_mouse():
	var viewport = get_viewport()
	var mouse_position = get_global_mouse_position()
	
	const screen_size_offset = 100
	var screen_size = get_viewport_transform().get_scale() + Vector2(screen_size_offset, screen_size_offset)
	var offscreen = Vector2(screen_size.x, screen_size.y)
	Utils.LogGD("position: " + str(mouse_position) + ", offscreen: " + str(offscreen), self)
	
	Utils.LogGD("vp: " + str(viewport.get_mouse_position()), self)
	Utils.LogGD("wd: " + str(get_window().get_mouse_position()), self)
	Utils.LogGD("global: " + str(get_global_mouse_position()), self)
	Utils.LogGD("local: " + str(get_local_mouse_position()), self)
	Input.warp_mouse(mouse_position)
	#await get_tree().process_frame
	Input.warp_mouse(offscreen)
	#await get_tree().process_frame
	$Loading.show()
	Input.warp_mouse(mouse_position)
	Utils.LogGD("warped: " + str(get_global_mouse_position()), self)
	Input.warp_mouse(get_viewport_rect().size / 2.0)
	Utils.LogGD("warped: " + str(get_global_mouse_position()), self)
	Input.warp_mouse(mouse_position)
	Utils.LogGD("warped: " + str(get_global_mouse_position()), self)
	await get_tree().process_frame
	$Loading.hide()


func get_mouse_arrow():
	return this_arrow
func get_mouse_hand():
	return this_hand
func get_mouse_color():
	return cursor_color
