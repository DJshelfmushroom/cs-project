extends TextEdit

func _process(delta: float) -> void:
	if (get_parent().get_parent().get_parent().completed == true):
		editable = false
