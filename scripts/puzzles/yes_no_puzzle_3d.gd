extends Node3D

var id = 10

var completed = false
var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
var currentletters = []
var nums = []
var yes = false
var done = 0
var hardmode = false

func _ready() -> void:
	if hardmode == false:
		normal_setup()
	else:
		hard_setup()
		
		
func normal_setup():
	$Screen3D.set_size(2.7,0.9)
	$Screen3D.position = Vector3(-0.5,0.16,0.001)
	for x in range(4):
		var rand = randi_range(0,25)
		currentletters.append(letters[rand])
	for y in range(4):
			for x in range(letters.size()):
				if letters[x] == currentletters[y]:
					nums.append(x)
	var rand2 = randi_range(1,2)
	if rand2 == 1:
		$Label3D.text = currentletters[0] + " + " + currentletters[1] + " > " + currentletters[2] + " + " + currentletters[3]
		if (nums[0] + nums[1]) > (nums[2] + nums[3]):
			yes = true
		else:
			yes = false
	else:
		$Label3D.text = currentletters[0] + " + " + currentletters[1] + " < " + currentletters[2] + " + " + currentletters[3]
		if (nums[0] + nums[1]) < (nums[2] + nums[3]):
			yes = true
		else:
			yes = false
			

func hard_setup():
	$Screen3D.set_size(3.8,0.9)
	$Screen3D.position = Vector3(-0.45,0.16,0.001)
	for x in range(6):
		var rand = randi_range(0,25)
		currentletters.append(letters[rand])
	for y in range(6):
			for x in range(letters.size()):
				if letters[x] == currentletters[y]:
					nums.append(x)
	var rand2 = randi_range(1,2)
	if rand2 == 1:
		$Label3D.text = currentletters[0] + " + " + currentletters[1] + " + " + currentletters[2] + " > " + currentletters[3] + " + " + currentletters[4] + " + " + currentletters[5]
		if (nums[0] + nums[1] + nums[2]) > (nums[3] + nums[4] + nums[5]):
			yes = true
		else:
			yes = false
	if rand2 == 2:
		$Label3D.text = currentletters[0] + " + " + currentletters[1] + " + " + currentletters[2] + " < " + currentletters[3] + " + " + currentletters[4] + " + " + currentletters[5]
		if (nums[0] + nums[1] + nums[2]) < (nums[3] + nums[4] + nums[5]):
			yes = true
		else:
			yes = false
			

func _process(_delta: float) -> void:
	if done >= 3:
		completed = true
		$Label3D.modulate = Color.GREEN

func _on_but_pressed(_num : int):
	if !$"../../..".failed && !completed:
		if ($Switch3D.up && yes) || (!$Switch3D.up && !yes):
			done += 1
			get_node("Node3D/Label3D" + str(done)).modulate = Color.GREEN
			if done < 3:
				nums = []
				currentletters = []
				_ready()
		else:
			var color = $Label3D.modulate
			$Label3D.modulate = Color.RED
			$"../../..".strikes += 1
			await get_tree().create_timer(1.0).timeout
			$Label3D.modulate = color
			nums = []
			currentletters = []
			_ready()
			
	
func _on_but_released(_num : int):
	pass
	
func _on_switch_flipped(_num : int):
	pass
