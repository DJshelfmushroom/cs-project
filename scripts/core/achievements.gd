extends Node

var allAchievements = ["test", "test2", "Reached Level 5"]
var completedAchievements = []


func completed_achievement(achievementName):
	var achievement = allAchievements.find(achievementName)
	if !completedAchievements.has(achievementName):
		completedAchievements.append(allAchievements[achievement])
		print(allAchievements, completedAchievements)
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
