class_name main_menu extends Node3D

func _ready() -> void:
	#load_settings(self)
	
	print("Happy end of the year guys")
	
	
	$Control/CustomCursor.set_mouse_cursor(SaveManager.arrow, SaveManager.hand, load("res://assets/cursor/RedWire_Dot.png"), SaveManager.color)
	SaveManager.save()
	if SaveManager.firstTime == true:
		run_tutorial()
	if (SaveManager.level >= 5):
		Achievements.completed_achievement("Reached Level 5")
	if (SaveManager.level >= 10):
		Achievements.completed_achievement("Dynamic Duo")
	if (SaveManager.level >= 15):
		Achievements.completed_achievement("Complete the Triumvirate")

func tutorial_speech_flash(seconds):
	$Control/TutorialSpeech.show()
	await get_tree().create_timer(seconds).timeout
	$Control/TutorialSpeech.hide()
	return

func disable_buttons(string):
	if string == "yes":
		$Control/PlayButton.disabled = true
		$Control/TutorialsButton.disabled = true
		$Control/PacksButton.disabled = true
		$Control/PracticeButton.disabled = true
		$Control/MouseOptionsButton.disabled = true
		$Control/AchievementsButton.disabled = true
		$Control/SettingsButton.disabled = true
	elif string == "no":
		$Control/PlayButton.disabled = false
		$Control/TutorialsButton.disabled = false
		$Control/PacksButton.disabled = false
		$Control/PracticeButton.disabled = false
		$Control/MouseOptionsButton.disabled = false
		$Control/AchievementsButton.disabled = false
		$Control/SettingsButton.disabled = false
	
func create_speech(text:String, position_x:float, position_y:float, font_size:int): #, flash_duration):
	$Control/TutorialSpeech.add_theme_font_size_override("font_size", font_size)
	$Control/TutorialSpeech.set_position(Vector2(position_x, position_y))
	$Control/TutorialSpeech.text = text
	await tutorial_speech_flash(6.7)

func run_tutorial():
	print("running tutorial")
	disable_buttons("yes")
	await create_speech("Welcome to RedWire. This quick tutorial will 
	provide you with an overview of the main menu", 650, 600, 40)
	await create_speech("In this game, you will complete puzzles to diffuse a bomb before 
	it explodes. To start a round, you'll press the play button", 600, 610, 40)
	await create_speech("However, you can't solve the puzzles without knowing how they work. 
	If you want to learn how to complete a puzzle, click the instructions button", 600, 1000, 30)
	await create_speech("Instructions will only take you so far though. To practice a 
	puzzle without the threat of a timer, go to the practice menu", 365, 700, 30)
	await create_speech("To view your settings, unlocked 
	cursors, or achivements, click on 
	these buttons", 1250, 585, 40)
	await create_speech("That's all for now. Have fun playing!", 650, 600, 40)
	disable_buttons("no")
	SaveManager.firstTime = false
	Achievements.completed_achievement("Complete Tutorial")

static func load_settings(caller:Node) -> void:
	var settings_path = "res://scenes/menus/SettingsSub/"
	var settings_dir = DirAccess.open(settings_path)
	var settings_files = settings_dir.get_files()
	var settings_scripts : Array[PackedScene]
	for file in settings_files:
		if !file.contains("Settings") or !file.contains("tscn"):
			continue
		var to_path = load(settings_path + "/" + file)
		settings_scripts.append(to_path)
	for script in settings_scripts:
		ResourceLoader.load_threaded_request(script.resource_path)
		var scene = ResourceLoader.load_threaded_get(script.resource_path)
		var instantiated = scene.instantiate()
		instantiated.visible = false
		caller.add_child(instantiated)
		caller.remove_child(instantiated)
		instantiated.queue_free()
	

func _on_play_button_up() -> void:
	get_tree().change_scene_to_file("res://bomb/Game3d.tscn")

func _on_tutorials_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/tutorials.tscn")


func _on_packs_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/packs.tscn")


func _on_practice_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/practice_menu.tscn")

func _on_mouse_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/Mouse_options.tscn")

func _on_achievements_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/Achievements.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/Settings.tscn");
	pass # Replace with function body.
