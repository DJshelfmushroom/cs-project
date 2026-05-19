extends Label

func _ready():
	hide()
	set_position(Vector2(395, 970))
	

func _process(delta: float) -> void:
	if SaveManager.addedxp == null || SaveManager.addedxp == 0:
		pass
	else:
		show()
		text = "+" + str(SaveManager.addedxp)
		await get_tree().create_timer(0.6).timeout
		if position.x > 355:
			position.x -= 1 * (delta * 60)
			
			#if get_tree() != null:
				#await get_tree().process_frame # TODO PLEASE FIX THIS
			#elif Utils.GetSceneTree() != null:
				#
			#await Utils.GetSceneTree().process_frame
		else:
			hide()
			SaveManager.addedxp = 0
