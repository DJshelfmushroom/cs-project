extends Node

var allAchievements = ["Complete Tutorial", "test2", "Reached Level 5", "Beat game with fourth left", "Beat game with third left", "Don't disable the puzzle", "Dynamic Duo", "Complete the Triumvirate", "It's a me"]
var completedAchievements = []


func completed_achievement(achievementName):
	if !completedAchievements.has(achievementName):
		completedAchievements.append(achievementName)
		SaveManager.save()


func check_achievement_completed(num):
	if num < 0 or num >= allAchievements.size():
		return false
	var thisAchievement = allAchievements[num]
	return completedAchievements.has(thisAchievement)


func load_achievements(savedAchievements):
	if savedAchievements is Array:
		completedAchievements = savedAchievements
	else:
		completedAchievements = []
	

func clear_achievements(): #used for testing
	for x in completedAchievements:
		completedAchievements.erase(x)
