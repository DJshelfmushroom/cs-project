extends Node

var allAchievements = ["test", "test2", "Reached Level 5", "Beat game under 1:30", "Beat game under 1:00", "Don't disable the puzzle"]
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
