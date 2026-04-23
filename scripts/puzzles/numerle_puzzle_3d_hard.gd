extends Node3D

var id = 5

var labels = []
var blanks = []
var bigblanks = []
var selected = 0
var answer = []
var nums = [1,2,3,4,5,6,7,8,9]
var completed = false
var practice = true
var just_entered = false

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
	blanks.append(get_node("BlankLabel1"))
	bigblanks.append(get_node("BlankLabel7"))
	bigblanks.append(get_node("BlankLabel8"))
	bigblanks.append(get_node("BlankLabel9"))
	$Screen3D.set_size(4.4,1.4)
	$Screen3D.position = Vector3(-0.122,0.2,0.001)
	for x in range(6):
		labels[x].text = ""
		var rand = randi_range(0,nums.size() - 1)
		answer.append(nums[rand])
		nums.remove_at(rand)
		
#func _process(_delta: float) -> void:
		#if labels[selected].text == str(answer[selected]):
			#if selected != 5:
				#selected += 1
			#else:
				#selected = 0
		#var wrong = false
		#for x in range(6):
			#if labels[x].text != str(answer[x]):
				#wrong = true
		#if !wrong:
			#completed = true
			#for x in range(6):
				#blanks[x].modulate = Color.WHITE
		#for x in range(6):
			#if labels[x].text == str(answer[x]):
				#labels[x].modulate = Color.GREEN
				#for y in range(6):
					#if y != x and labels[y].text == str(answer[x]):
						#labels[y].modulate = Color.WHITE
			#else:
				#for y in range(6):
					#if labels[x].text == str(answer[y]):
						#labels[x].modulate = Color.YELLOW
						#for z in range(6):
							#if y != x and labels[y].text == labels[x].text:
								#if str(answer[y]) != labels[y].text:
									#labels[y].modulate = Color.WHITE
								#else:
									#labels[x].modulate = Color.WHITE
		#if selected != 0 and !completed:
			#blanks[selected].modulate = Color.ORANGE
			#blanks[selected - 1].modulate = Color.WHITE
			#blanks[selected + 1].modulate = Color.WHITE
		#elif !completed:
			#blanks[0].modulate = Color.ORANGE
			#blanks[1].modulate = Color.WHITE
			#blanks[2].modulate = Color.WHITE
			#blanks[3].modulate = Color.WHITE
			#blanks[4].modulate = Color.WHITE
			#blanks[5].modulate = Color.WHITE
			#
			#
	

func _on_button_pressed(num : int):
	if !completed: #and !$"../../..".failed:
		if num != 10:
			if just_entered:
				for x in blanks:
					x.modulate = Color.WHITE
				for x in labels:
					x.text = ""
			if selected < 6:
				labels[selected].text = str(num)
				selected += 1
				if selected < 5:
					blanks[selected + 1].modulate = Color.ORANGE
				else:
					blanks[5].modulate = Color.WHITE
		else:
			just_entered == true
			selected = 0
			blanks[0].modulate = Color.ORANGE
			for x in range(0, 6, 2):
				if str(answer[x]) == labels[x].text:
					blanks[x].modulate = Color.GREEN
				elif str(answer[x+1]) == labels[x].text:
					blanks[x].modulate = Color.YELLOW
				if str(answer[x+1]) == labels[x+1].text:
					blanks[x+1].modulate = Color.GREEN
				elif str(answer[x]) == labels[x+1].text:
					blanks[x+1].modulate = Color.YELLOW
		
		
		
		
	
func _on_button_released(_num : int):
	pass
