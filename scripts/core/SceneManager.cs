using System.Collections.Generic;
using System.Linq;
using Godot;
// using csproject.scripts

namespace csproject.scripts.core;

public partial class SceneManager : Node
{
	private static readonly List<StringName> SceneHistory = new ();
	
	public static void ChangeScene(Node self, string sceneTo)
	{
		SceneTree tree = self.GetTree();
		Node currentNode = tree.CurrentScene;
		SceneHistory.Add(currentNode.SceneFilePath);
		tree.ChangeSceneToFile(sceneTo);
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
}
