extends Node3D

var id = 5

var labels = []
var blanks = []
var bigblanks = []
var selected = 0
var answer = []
var answer2 = []
var nums = [1,2,3,4,5,6,7,8,9]
var completed = false
var practice = true
var just_entered = false
var phase = 0
var colors = [Color.RED, Color.CYAN, Color.MAGENTA]

func _ready() -> void:
	labels.append(get_node("Label1"))
	labels.append(get_node("Label2"))
	labels.append(get_node("Label3"))
	labels.append(get_node("Label4"))
	labels.append(get_node("Label5"))
	labels.append(get_node("Label6"))
	blanks.append(get_node("BlankLabel1"))
	blanks.append(get_node("BlankLabel2"))
	blanks.append(get_node("BlankLabel3"))
	blanks.append(get_node("BlankLabel4"))
	blanks.append(get_node("BlankLabel5"))
	blanks.append(get_node("BlankLabel6"))
	bigblanks.append(get_node("BlankLabel7"))
	bigblanks.append(get_node("BlankLabel8"))
	bigblanks.append(get_node("BlankLabel9"))
	$Screen3D.set_size(4.4,1.4)
	$Screen3D.position = Vector3(-0.122,0.2,0.001)
	blanks[0].modulate = Color.ORANGE
	for x in range(6):
		labels[x].text = ""
		var rand = randi_range(0,nums.size() - 1)
		answer.append(nums[rand])
		nums.remove_at(rand)
	answer2 = answer.duplicate()
	answer2.shuffle()
	

func _on_button_pressed(num : int):
	
	if !completed and !$"../../..".failed:
		for b in blanks:
			b.modulate = Color.WHITE
		if num != 10:
			if just_entered:
				for x in blanks:
					x.modulate = Color.WHITE
				for x in labels:
					x.text = ""
				just_entered = false
			if selected < 6:
				labels[selected].text = str(num)
				selected += 1
				if selected < 5:
					blanks[selected].modulate = Color.ORANGE
				else:
					blanks[5].modulate = Color.ORANGE
		else:
			if phase == 0:
				var cont = true
				for l in labels:
					if l.text == "":
						cont = false
				if cont and !just_entered:
					just_entered = true
					selected = 0
					for x in range(6):
						if labels[x].text == str(answer[x]):
							blanks[x].modulate = Color.GREEN
						else:
							for y in range(6):
								if labels[x].text == str(answer[y]):
									blanks[x].modulate = Color.YELLOW
				else:
					blanks[selected].modulate = Color.ORANGE
				var phase_completed = true
				for z in range(6):
					if labels[z].text != str(answer[z]):
						phase_completed = false
				if phase_completed:
					phase += 1
			if phase == 1:
				just_entered = true
				selected = 0
				for x in range(6):
					for y in range(6):
						if labels[y].text == str(answer2[x]):
							blanks[y].modulate = colors[x / 2]
				for z in range(0,6,2):
					if labels[z].text == str(answer2[z]) && labels[z+1].text == str(answer2[z+1]):
						bigblanks[z / 2].modulate = Color.GREEN
					elif labels[z].text == str(answer2[z+1]) && labels[z+1].text == str(answer2[z]):
						bigblanks[z / 2].modulate = Color.YELLOW
				var phase2_completed = true
				for z in range(6):
					if labels[z].text != str(answer2[z]):
						phase2_completed = false
				if phase2_completed:
					completed = true
					for b in blanks:
						b.modulate = Color.GREEN
					for l in labels:
						l.modulate = Color.GREEN
				
			
				
		
		
		
		
	
func _on_button_released(_num : int):
	pass
