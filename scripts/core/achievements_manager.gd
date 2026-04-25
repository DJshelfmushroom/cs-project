extends Node

var allAchievements = ["test", "test2", "Reached Level 5", "Beat game under 1:30", "Beat game under 1:00", "Don't disable the puzzle"]
var completedAchievements = []


func completed_achievement(achievementName):
	var achievement = allAchievements.find(achievementName)
	if !completedAchievements.has(achievementName):
		completedAchievements.append(allAchievements[achievement])
		SaveManager.save()
	else:
		pass
	

func check_achievement_completed(num):
	var thisAchievement = allAchievements[num]
	if allAchievements.has(thisAchievement) && completedAchievements.has(thisAchievement):
		return true
	else:
		return false	


func load_achievements(savedAchievements):
	completedAchievements = savedAchievements
	

func clear_achievements(): #used for testing
	for x in completedAchievements:
		completedAchievements.erase(x)
