using Godot;
using System;
using System.Xml.Schema;

public partial class Button : Godot.Button
{
	void _on_pressed()
	{
		GD.Print("Pressed");
		SetPhysicsProcess(false);
		SceneManager.ChangeScene("res://menus/pause.tscn");
	}
}
