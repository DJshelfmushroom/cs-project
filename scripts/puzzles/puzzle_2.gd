extends Node3D

var completed
var nums = [1,1,2,2,3,3,4,4,5,5,6,6]
var buttons = []
var button_scene = preload("res://scenes/components/memory_button_3d.tscn")
var gen = RandomNumberGenerator.new()
var b1 = null
var b2 = null
var thisfailed = false
var practice = true
	
func _ready() -> void:
	completed = false
	var index = 0
	var y = 0
	for i in range(3):
		var x = 0
		for j in range(4):
			var buttoninst = button_scene.instantiate()
			add_child(buttoninst)
			buttoninst.position = Vector3(x / 10.0, y / -10.0, 0)
			buttoninst.index = index
			buttoninst.set_text("")
			buttons.append(buttoninst)
			x += 3
			index += 1
		y += 3
	for button in buttons:
		var rand = gen.randi_range(0,nums.size() - 1)
		button.num = nums[rand]
		nums.remove_at(rand)
		
func _process(_delta: float) -> void:
	var win = true
	for button in buttons:
		if (button.text == ""):
			win = false
	if (win == true):
		completed = true
		for button in buttons:
			button.set_color(Color.GREEN)
	#if (completed && practice):
		#$RedWireButton.visible = true

func _on_but_pressed(b : int):
	if (not(thisfailed)):
		if (b1 == null):
			b1 = buttons[b]
			b1.on()
		elif (b2 == null):
			b2 = buttons[b]
			b2.on()
			if (not(b2.num == b1.num)):
				for button in buttons:
					button.disabled = true
				await get_tree().create_timer(1.0).timeout
				b1.off()
				b2.off()
				for button in buttons:
					if (button.set_text("")):
						button.disabled = false
			b1 = null
			b2 = null

func _on_but_released(x : int):
	pass

#func _on_red_wire_button_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/menus/practice_menu.tscn")
