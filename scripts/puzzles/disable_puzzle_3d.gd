extends Node3D

var completed = false

func _ready() -> void:
	$Screen3D.set_size(2.7,0.6)
	$Screen3D.position = Vector3(0.7,-0.35,-0.0002)

func _process(_delta: float) -> void:
	if $TextEdit3D.text.to_lower() == "disable_defense\u200B" || $TextEdit3D.text.to_lower() == "disable_defense|\u200B" || $TextEdit3D.text.to_lower() == "disable_defense\u200B|":
		if !$"../../..".failed:
			completed = true
			$TextEdit3D.visible = false
			$Disabled.visible = true
	elif $TextEdit3D.text.contains("\u200B"):
		$DisableFailed.visible = true
		$TextEdit3D.visible = false
		$"../../..".strikes += 1
		$TextEdit3D.text = ""
		await get_tree().create_timer(1.0).timeout
		$DisableFailed.visible = false
		$TextEdit3D.visible = true
		

func _on_but_pressed(num : int):
	if !$"../../..".failed:
		$EnterButton.visible = false
		$TextEdit3D.visible = true
		$TextEdit3D.disabled = false

func _on_but_released(num : int):
	pass
