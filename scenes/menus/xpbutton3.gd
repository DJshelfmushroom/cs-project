extends Button

func _ready() -> void:
	if Utils.GetDebug():
		self.show()

func _on_pressed() -> void:
	SaveManager.totalxp = 0
	SaveManager.level = 0
