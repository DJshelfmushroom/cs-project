using Godot;
using System;
using System.Collections.Specialized;
using System.Linq;

public partial class SceneManager : Node
{
	 public Node[] sceneHistory;

	string ChangeScene(PackedScene sceneTo)
	{
		SceneTree tree = GetTree();
		Node current = tree.CurrentScene;
		sceneHistory.Append(current);
		tree.ChangeSceneToFile(sceneTo);
		// tree.ChangeSceneToFile(sceneTo.ResourceName);
		
	}
}
