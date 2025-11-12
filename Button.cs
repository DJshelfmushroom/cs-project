using Godot;
using System;
using System.Xml.Schema;

public partial class Button : Godot.Button
{
	void _on_pressed()
	{
		GD.Print("Pressed");
		// GetTree().SetPause(true);
		SetPhysicsProcess(false);
		SceneManager.ChangeScene("res://pause_menu.tscn");
		
	}
}
