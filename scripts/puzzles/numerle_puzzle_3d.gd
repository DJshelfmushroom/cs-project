extends Node3D

var labels = []
var blanks = []
var selected = 0
var answer = []
var nums = [1,2,3,4,5,6,7,8,9]
var completed = false
var practice = true

func _ready() -> void:
	labels.append(get_node("Label1"))
	labels.append(get_node("Label2"))
	labels.append(get_node("Label3"))
	blanks.append(get_node("BlankLabel1"))
	blanks.append(get_node("BlankLabel2"))
	blanks.append(get_node("BlankLabel3"))
	blanks.append(get_node("BlankLabel1"))
	$Screen3D.set_size(2.5,1.3)
	$Screen3D.position = Vector3(-0.112,-0.01,-0.001)
	for x in range(3):
		labels[x].text = ""
		var gen = RandomNumberGenerator.new()
		var rand = gen.randi_range(0,nums.size() - 1)
		answer.append(nums[rand])
		nums.remove_at(rand)
		
func _process(_delta: float) -> void:
		if labels[selected].text == str(answer[selected]):
			if selected != 2:
				selected += 1
			else:
				selected = 0
		var wrong = false
		for x in range(3):
			if labels[x].text != str(answer[x]):
				wrong = true
		if !wrong:
			completed = true
			for x in range(3):
				blanks[x].modulate = Color.WHITE
		for x in range(3):
			if labels[x].text == str(answer[x]):
				labels[x].modulate = Color.GREEN
				for y in range(3):
					if y != x and labels[y].text == str(answer[x]):
						labels[y].modulate = Color.WHITE
			else:
				for y in range(3):
					if labels[x].text == str(answer[y]):
						labels[x].modulate = Color.YELLOW
						for z in range(3):
							if y != x and labels[y].text == labels[x].text:
								if str(answer[y]) != labels[y].text:
									labels[y].modulate = Color.WHITE
								else:
									labels[x].modulate = Color.WHITE
		if selected != 0 and !completed:
			blanks[selected].modulate = Color.ORANGE
			blanks[selected - 1].modulate = Color.WHITE
			blanks[selected + 1].modulate = Color.WHITE
		elif !completed:
			blanks[0].modulate = Color.ORANGE
			blanks[1].modulate = Color.WHITE
			blanks[2].modulate = Color.WHITE		
			
			
	

func _on_button_pressed(num : int):
	if !completed:
		labels[selected].text = str(num)
		labels[selected].modulate = Color.WHITE
		if selected < 2:
			selected += 1
		else:
			selected = 0
		
		
		
	
func _on_button_released(num : int):
	pass
