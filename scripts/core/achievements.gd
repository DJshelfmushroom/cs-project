extends Node

var allAchievements = ["test", "test2"]
var completedAchievements = []


func completed_achievement(achievementName):
	var achievement = allAchievements.find(achievementName)
	if !completedAchievements.has(achievementName):
		completedAchievements.append(allAchievements[achievement])
		print(allAchievements, completedAchievements)
	else:
		pass
	

func load_achievements(savedAchievements):
	completedAchievements = savedAchievements
	

func clear_achievements(): #used for testing
	for x in completedAchievements:
		completedAchievements.erase(x)
