extends Node2D

var paths = ["res://packitems/blue.png","res://packitems/green.png","res://packitems/purple.png"]
var gen = RandomNumberGenerator.new()
var rand
var texture
var num

func _ready() -> void:
	rand = gen.randi_range(1,100)
	if (rand > 85):
		texture = load("res://packitems/purple.png")
		$ItemLabel.text = "PURPLE"
	elif (rand > 50):
		texture = load("res://packitems/blue.png")
		$ItemLabel.text = "BLUE"
	else:
		texture = load("res://packitems/green.png")
		$ItemLabel.text = "GREEN"
	$PackSprite.texture = texture

func _process(_delta: float) -> void:
	if ($PackSprite.position.y < 540):
		num = (540 - $PackSprite.position.y) / 15
		$ItemLabel.position.y += num
		$PackSprite.position.y += num
	else:
		$PackSprite.position.y = 540
		$ItemLabel.position.y = 820


func _on_back_button_button_up() -> void:
	get_tree().change_scene_to_file("res://packs.tscn")
