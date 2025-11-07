extends Button


func _on_pressed() -> void:
	SaveManager.save()
	get_tree().quit()
