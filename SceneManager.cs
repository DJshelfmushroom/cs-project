using System.Collections.Generic;
using System.Linq;
using Godot;

public partial class SceneManager : Node
{
	private static List<Node> SceneHistory = new List<Node>();
	private SceneTree _tree;
	private Node _currentNode;

	
	public void ChangeScene(Node self, string sceneTo)
	{
		_tree = self.GetTree();
		_currentNode = _tree.CurrentScene;
		SceneHistory.Add(_currentNode);
		_tree.ChangeSceneToFile(sceneTo);
		GD.Print(SceneHistory.ToString());
	}

	public void ReturnToScene(Node self)
	{
		GD.Print(SceneHistory.ToString());
		// ßSceneHistory.Remove(self);
		GD.Print(SceneHistory.ToString());
		_tree = self.GetTree();
		_currentNode = _tree.CurrentScene;
		Node goTo = SceneHistory.First();
		GD.Print($"sceneFilePath: {goTo}");
		_tree.ChangeSceneToFile(goTo.SceneFilePath);
	}


}
