extends Node3D

var completed
var strikeable = true
@onready var TextEdit1 = $EquationLabel/AnswerLabel/TextEdit3D
@onready var TextEdit2 = $EquationLabel/AnswerLabel/TextEdit3D2
var practice = true

func _ready() -> void:
	completed = false

func _process(_delta: float) -> void:
	if ((TextEdit1.text_buffer == str($EquationLabel.get_rand1()) && TextEdit2.text_buffer == str($EquationLabel.get_rand2())) \
	or (TextEdit1.text_buffer == str($EquationLabel.get_rand2()) && TextEdit2.text_buffer == str($EquationLabel.get_rand1()))):
		completed = true
	elif (not(TextEdit1.text_buffer == "") && not(TextEdit2.text_buffer == "") && strikeable == true):
		TextEdit1.editable = false
		TextEdit1.label.modulate = Color.RED
		TextEdit2.editable = false
		TextEdit2.label.modulate = Color.RED
		#$"..".strikes += 1
		strikeable = false
		await get_tree().create_timer(1.0).timeout
		TextEdit1.text_buffer = ""
		TextEdit2.text_buffer = ""
		TextEdit1.label.text = ""
		TextEdit2.label.text = ""
		TextEdit1.editable = true
		TextEdit1.label.modulate = Color.WHITE
		TextEdit2.editable = true
		TextEdit2.label.modulate = Color.WHITE
		strikeable = true
	#if (completed && practice):
	#	$RedWireButton.visible = true


func _on_red_wire_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/practice_menu.tscn")
