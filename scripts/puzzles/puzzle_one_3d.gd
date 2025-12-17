extends Node3D

var completed
var strikeable = true
@onready var TextEdit1 = $EquationLabel/AnswerLabel/Num1
@onready var TextEdit2 = $EquationLabel/AnswerLabel/Num2
var practice = true
var current_text = 1


func _ready() -> void:
	completed = false
	

func _process(_delta: float) -> void:
	if (TextEdit1.text == str($EquationLabel.get_x()) and TextEdit2.text == str($EquationLabel.get_y())):
		TextEdit1.editable = false
		TextEdit1.modulate = Color.GREEN
		TextEdit2.editable = false
		TextEdit2.modulate = Color.GREEN
		completed = true
	elif (not(TextEdit1.text == "") && not(TextEdit2.text == "") && strikeable == true):
		TextEdit1.editable = false
		TextEdit1.modulate = Color.RED
		TextEdit2.editable = false
		TextEdit2.modulate = Color.RED
		#$"..".strikes += 1
		strikeable = false
		await get_tree().create_timer(1.0).timeout
		TextEdit1.text = ""
		TextEdit2.text = ""
		TextEdit1.editable = true
		TextEdit1.modulate = Color.WHITE
		TextEdit2.editable = true
		TextEdit2.modulate = Color.WHITE
		strikeable = true
		current_text = 1
	#if (completed && practice):
	#	$RedWireButton.visible = true
	
func _on_button_pressed(num : int):
	if current_text == 1 and TextEdit1.editable:
		current_text = 2
		TextEdit1.set_text(str(num))
		
		
	elif current_text == 2 and TextEdit2.editable:
		current_text = 0
		TextEdit2.set_text(str(num))
		
	
func _on_button_released(num : int):
	pass
	


func _on_red_wire_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/practice_menu.tscn")
