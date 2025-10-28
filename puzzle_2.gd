extends Control

var completed
var nums = [1,1,2,2,3,3,4,4,5,5,6,6]
var buttons = []
var button_scene = preload("res://but_1.tscn")
var gen = RandomNumberGenerator.new()
var b1 = null
var b2 = null
	
func _ready() -> void:
	completed = false
	var index = 0
	var y = 0
	for i in range(3):
		var x = 0
		for j in range(4):
			var buttoninst = button_scene.instantiate()
			add_child(buttoninst)
			buttoninst.position = Vector2(x,y)
			buttoninst.index = index
			buttons.append(buttoninst)
			x += 300
			index += 1
		y += 300
	for button in buttons:
		var rand = gen.randi_range(0,nums.size() - 1)
		button.num = nums[rand]
		nums.remove_at(rand)
		
func _process(delta: float) -> void:
	var win = true
	for button in buttons:
		if (button.text == ""):
			win = false
	if (win == true):
		completed = true
		for button in buttons:
			button.add_theme_color_override("font_disabled_color","green")

func _on_but_pressed(b : int) -> void:
	if (get_parent().failed == false):
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
					if (button.text == ""):
						button.disabled = false
			b1 = null
			b2 = null
