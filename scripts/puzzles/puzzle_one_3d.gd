extends Node3D

var completed
var strikeable = true
@onready var TextEdit1 = $EquationLabel/AnswerLabel/TextEdit1
@onready var TextEdit2 = $EquationLabel/AnswerLabel/TextEdit2
var practice = true

func _ready() -> void:
	completed = false

func _process(_delta: float) -> void:
	if ((TextEdit1.text == str($EquationLabel.get_rand1()) && TextEdit2.text == str($EquationLabel.get_rand2())) \
	or (TextEdit1.text == str($EquationLabel.get_rand2()) && TextEdit2.text == str($EquationLabel.get_rand1()))):
		completed = true
	elif (not(TextEdit1.text == "") && not(TextEdit2.text == "") && strikeable == true):
		TextEdit1.editable = false
		TextEdit1.add_theme_color_override("font_readonly_color","red")
		TextEdit2.editable = false
		TextEdit2.add_theme_color_override("font_readonly_color", "red")
		$"..".strikes += 1
		strikeable = false
		await get_tree().create_timer(1.0).timeout
		TextEdit1.text = ""
		TextEdit2.text = ""
		TextEdit1.editable = true
		TextEdit1.add_theme_color_override("font_readonly_color","green")
		TextEdit2.editable = true
		TextEdit2.add_theme_color_override("font_readonly_color", "green")
		strikeable = true
	if (completed && practice):
		$RedWireButton.visible = true


func _on_red_wire_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/practice_menu.tscn")
