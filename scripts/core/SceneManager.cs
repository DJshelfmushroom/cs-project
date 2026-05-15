using System.Collections.Generic;
using System.Linq;
using Godot;
using GodotPlugins.Game;

// using csproject.scripts

namespace csproject.scripts.core;

public partial class SceneManager : Node
{
	private static readonly List<StringName> SceneHistory = new ();
	private static readonly GDScript MainMenu = GD.Load<GDScript>("res://scripts/menus/main_menu.gd");

	private void CallLoadSettings()
	{
		MainMenu.CallDeferred("load_settings", this);
	}

	public static void ChangeScene(Node self, string sceneTo)
	{
		SceneTree tree = self.GetTree();
		Node currentNode = tree.CurrentScene;
		SceneHistory.Add(currentNode.SceneFilePath);
		tree.ChangeSceneToFile(sceneTo);
		// menus.main_menu.load_settings(this);
		
		GD.Print(SceneHistory.Last(), " len: ", SceneHistory.Count);
	}

	public static void ReturnToScene(Node self)
	{
		// GD.Print(_sceneHistory.ToString());
		// ßSceneHistory.Remove(self);
		// GD.Print(_sceneHistory.ToString());
		SceneTree tree = self.GetTree();
		// Node currentNode = tree.CurrentScene;
		string goTo = SceneHistory[^1];
		GD.Print($"sceneFilePath: {goTo}");
		tree.ChangeSceneToFile(goTo);
		SceneHistory.RemoveAt(SceneHistory.Count - 1);
	}

	public override void _EnterTree()
	{
		base._EnterTree();
		CallLoadSettings();
	}

	public override void _Ready()
	{
		base._Ready();
		CallLoadSettings();
	}
}
