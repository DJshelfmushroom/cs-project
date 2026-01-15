extends Button

var puzzle_names = ["EQUATION PUZZLE", "MEMORY PUZZLE", "SIMON PUZZLE"]

func _process(_delta: float) -> void:
	text = puzzle_names[$"..".selected_puzzle]

func _on_pressed() -> void:
	if ($"..".selected_puzzle < puzzle_names.size() - 1):
		$"..".selected_puzzle += 1
	else:
		$"..".selected_puzzle = 0
