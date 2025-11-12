extends TextEdit

func _process(_delta: float) -> void:
	if (text.length() > 1):
		remove_text(0,1,0,2)
	if (get_parent().get_parent().get_parent().completed == true):
		add_theme_color_override("font_readonly_color","green")
		editable = false
		
