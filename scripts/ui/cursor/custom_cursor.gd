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


func fix_mouse_test():
	var viewport = get_viewport()
	var mouse_position = viewport.get_mouse_position()
	const screen_size_offset = 100
	var offscreen = Vector2(get_viewport_rect().size.x + screen_size_offset, get_viewport_rect().size.y + screen_size_offset)
	
	if (mouse_position.x > offscreen.x) || (mouse_position.y > offscreen.y): #when running the game
		await get_tree().process_frame
		mouse_position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	
	Input.warp_mouse(offscreen)
	$Loading.show()
	await get_tree().process_frame
	Input.warp_mouse(mouse_position)
	await get_tree().process_frame
	$Loading.hide()
	
	

func fix_mouse():
	var viewport = get_viewport()
	var viewport_scale : Vector2 = Vector2(viewport.size) / Vector2(1920, 1080)
	var window_scale = get_window().get_screen_transform().get_scale()
	var window_size = window_scale * Vector2(1920, 1080)
	var edge_size = (Vector2(viewport.size)- window_size) / 2
	#Utils.LogGD("window: " + str(window_size) + " viewport: " + str(viewport.size), self)
	#Utils.LogGD("Edge size: " + str(edge_size), self)
	var mouse_position = (get_global_mouse_position()) * window_scale + edge_size
	
	const screen_size_offset = 100
	var screen_size = window_size + Vector2(screen_size_offset, screen_size_offset)
	var offscreen = Vector2(screen_size.x, screen_size.y)

	Utils.LogGD("wd: " + str(get_window().get_mouse_position()), self)
	Input.warp_mouse(mouse_position)
	#await get_tree().process_frame
	Input.warp_mouse(offscreen)
	#$Loading.show()
	Input.warp_mouse(mouse_position)
	Utils.LogGD("warped: " + str(get_global_mouse_position()), self)
	#await get_tree().process_frame
	#$Loading.hide()


func get_mouse_arrow():
	return this_arrow
func get_mouse_hand():
	return this_hand
func get_mouse_color():
	return cursor_color
