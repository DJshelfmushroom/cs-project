extends Node3D

var id = 9

var completed = false
var switches = []
var dots = []
var answer = []
var current = []
var switch_scene = preload("res://scenes/components/switch_3d.tscn")

func _ready() -> void:
	$Screen3D.set_size(4.0,2.0)
	$Screen3D.position = Vector3(0.53,0.65,0.001)
	$Switch3D.visible = false
	var n = 0
	var j = -0.6
	for y in range(2):
		var i = -0.6
		for x in range(5):
			var switch_inst = switch_scene.instantiate()
			switch_inst.scale = Vector3(1.0,0.8,1.0)
			switch_inst.num = n
			switch_inst.position = Vector3(i,j,-0.01)
			switches.append(switch_inst)
			add_child(switch_inst)
			var rand = randi_range(1,2)
			if rand == 1:
				switch_inst.flip()
			var rand2 = randi_range(1,2)
			if rand2 == 1:
				answer.append(n)
			n += 1
			i += 0.7
		j -= 1.23
	var m = 0
	var d = 2.15
	for y in range(2):
		var c = -0.6
		for x in range(5):
			var dot = Label3D.new()
			dot.text = "."
			dot.pixel_size = 0.0005
			dot.font = load("res://assets/fonts/Seven Segment.ttf")
			dot.font_size = 10000
			dot.outline_size = 0
			dot.position = Vector3(c,d,0.002)
			for i in range(answer.size()):
				if answer[i] == m:
					dot.modulate = Color.YELLOW
			add_child(dot)
			dots.append(dot)
			c += 0.8
			m += 1
		d += 0.95
			
			
		
func _process(_delta: float) -> void:
	if (completed): return
	if current.size() == answer.size():
		var win = true
		for x in range(answer.size()):
			var ismatch = false
			for y in range(answer.size()):
				if answer[x] == current[y]:
					ismatch = true
			if !ismatch:
				win = false
		if win:
			completed = true
			for switch in switches:
				switch.disabled = true
			for dot in dots:
				dot.modulate = Color.GREEN
				
		
func _on_switch_flipped(num : int):
	if !$"../../..".failed:
		if switches[num].up:
			current.append(num)
		else:
			for x in range(current.size()):
				if current[x] == num:
					current.remove_at(x)
					break
