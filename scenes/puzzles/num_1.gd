extends Label3D

var editable = true

func wait() -> void:
	if editable:
		editable = false
		await get_tree().create_timer(0.2).timeout
		editable = true
	else:
		await get_tree().create_timer(0.2).timeout
