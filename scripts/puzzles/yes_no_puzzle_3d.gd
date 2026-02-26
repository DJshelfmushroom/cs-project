extends Node3D

var completed = false
var letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
var currentletters = []
var nums = []
var yes = false
var done = 0

func _ready() -> void:
	$Screen3D.set_size(2.7,0.9)
	$Screen3D.position = Vector3(-0.5,0.56,-0.02)
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
			await get_tree().create_timer(1.0).timeout
			$"../../..".strikes += 1
			$Label3D.modulate = color
			nums = []
			currentletters = []
			_ready()
			
	
func _on_but_released(_num : int):
	pass
	
func _on_switch_flipped(_num : int):
	pass
