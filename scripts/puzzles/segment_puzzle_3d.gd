extends Node3D

var id = 6

var buttons = []
var completed = false
var allnums = [0,1,2,3,4,5,6,7,8,9]
var nums = []
var answer = []
var on = []
var segments = [
	[0,1,2,3,4,5],
	[1,2],
	[0,1,3,4,6],
	[0,1,2,3,6],
	[1,2,5,6],
	[0,2,3,5,6],
	[0,2,3,4,5,6],
	[0,1,2],
	[0,1,2,3,4,5,6],
	[0,1,2,3,5,6]]
var practice = true

func _ready() -> void:
	$Screen3D.set_size(2,1)
	$Screen3D.position = Vector3(0.07, 0.17, 0.001)
	for x in range(2):
		var gen = RandomNumberGenerator.new()
		var rand = gen.randi_range(0, allnums.size() - 1)
		nums.append(allnums[rand])
		allnums.remove_at(rand)
	$NumsLabel.text = str(nums[0]) + " | " + str(nums[1])
	
	for x in range(segments[nums[0]].size()):
		for y in range(segments[nums[1]].size()):
			if segments[nums[0]][x] == segments[nums[1]][y]:
				answer.append(segments[nums[0]][x])
	buttons.append(get_node("SB3D0"))
	buttons.append(get_node("SB3D1"))
	buttons.append(get_node("SB3D2"))
	buttons.append(get_node("SB3D3"))
	buttons.append(get_node("SB3D4"))
	buttons.append(get_node("SB3D5"))
	buttons.append(get_node("SB3D6"))
	for x in range(7):
		buttons[x].num = x
		
func _process(_delta: float) -> void:
	if !on.is_empty():
		var nomatch = false
		for x in range(answer.size()):
			var ismatch = false
			for y in range(on.size()):
				if answer[x] == on[y]:
					ismatch = true
			if !ismatch:
				nomatch = true
		if !nomatch:
			completed = true
			for x in range(buttons.size()):
				buttons[x].win()
			$NumsLabel.modulate = Color.GREEN
				
func _on_but_pressed(num : int):
	var ismatch = false
	for x in range(answer.size()):
		if answer[x] == num:
			on.append(num)
			buttons[num].set_lighting(Color.GREEN)
			buttons[num].disabled = true
			ismatch = true
	if !ismatch:
		buttons[num].set_lighting(Color.RED)
		$"../../..".strikes += 1
		buttons[num].disabled = true
		await get_tree().create_timer(1.0).timeout
		buttons[num].light_off()
		buttons[num].disabled = false
	
func _on_but_released(_num : int):
	pass
