extends Label

func _ready() -> void:
	position = Vector2(0,0)
	
	
func _process(delta) -> void: 
	var timer = $".."
	if (get_parent().get_parent().get_parent().get_child(2).completed == false && get_parent().get_parent().get_parent().get_child(2).failed == false):
		var seconds = int(timer.get_time_left())
		if (seconds < 10):
			text = "0:0" + str(seconds)
		elif (seconds < 60):
			text = "0:" + str(seconds)
		elif (seconds % 60 / 10 == 0):
			text = str(seconds / 60) + ":0" + str(seconds % 60)
		else: 
			text = str(seconds / 60) + ":" + str(seconds % 60)
	elif (get_parent().get_parent().get_parent().get_child(2).completed == true):
		add_theme_color_override("font_color", "green")
	add_theme_font_size_override("font_size", get_theme_font_size("font_size") * $".".scale.x)


func _on_timer_timeout() -> void:
	hide()
