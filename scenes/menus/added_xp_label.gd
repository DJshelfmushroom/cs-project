extends Label

func _ready():
	hide()
	set_position(Vector2(395, 970))
	

func _process(delta: float) -> void:
	if SaveManager.addedxp == null || SaveManager.addedxp == 0:
		pass
	else:
		text = "+" + str(SaveManager.addedxp)
		show()
		await get_tree().create_timer(0.6).timeout
		while position.x > 355:
			position.x -= 0.05 * delta * 150
			if get_tree() != null:
				await get_tree().process_frame # TODO PLEASE FIX THIS
			elif Utils.GetSceneTree() != null:
				await Utils.GetSceneTree().process_frame
		hide()
