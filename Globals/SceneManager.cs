using System;
using System.Collections.Generic;
using System.Linq;
using Godot;

public partial class SceneManager : Node
{
	private static List<string> SceneHistory = new List<string>();
	private static SceneTree _tree;
	private static Node _currentNode;
	
	public static void ChangeScene(string sceneTo)
	{
		GD.Print("Changing scene:");
		_tree = Engine.GetMainLoop() as SceneTree;
		if (_tree == null) {return;}
		_currentNode = _tree.CurrentScene;
		SceneHistory.Add(_currentNode.SceneFilePath);
		_tree.ChangeSceneToFile(sceneTo);
		foreach (string scenePath in SceneHistory)
		{
			GD.PrintRaw(scenePath + ',');
		}
		GD.Print();
	}

	public void ReturnToScene(Node self)
	{
		GD.Print("returning:");
		GD.Print(SceneHistory.ToString());
		SceneHistory.Remove(self.SceneFilePath);
		GD.Print(SceneHistory.ToString());
		_tree = self.GetTree();
		_currentNode = _tree.CurrentScene;
		string goTo = SceneHistory.First();
		GD.Print($"sceneFilePath: {goTo}");
		_tree.ChangeSceneToFile(goTo);
	}
}


public partial class Pause : Node
{
	// public override void _Ready()
	// {
	// 	// base._Ready();
	// 	GD.Print("PAUSE");
	// }

	public override void _UnhandledInput(InputEvent @event)
	{
		GD.Print(@event);
		if (@event is InputEventAction action)
		{
			if (Input.IsActionJustPressed("pause"))
			{
				SceneTree tree = Engine.GetMainLoop() as SceneTree;
				if (tree == null) {return;}
				tree.Paused = true;
				tree.ChangeSceneToFile("res://menus/pause.tscn");
			}
		}
	}
}
