extends Label

func _ready() -> void:
	position = Vector2(1550,0)

func _process(delta: float) -> void:
	text = "strikes: " + str($"..".strikes)
