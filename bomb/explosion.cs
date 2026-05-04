using Godot;
using System;
using System.Collections.Generic;
using csproject.scripts.core;

public partial class explosion : Node
{
	int frame = 0;
	bool hasExploded = false;
	private string[] sounds;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		var dir = DirAccess.Open("res://explosions");
		var	soundList = new List<string>();
		if (dir != null)
		{
			dir.ListDirBegin();
			string fileName = dir.GetNext();
			while (fileName != "")
			{
				if (!dir.CurrentIsDir() && !fileName.StartsWith(".") && !fileName.EndsWith(".import"))
				{
					soundList.Add("res://explosions/" + fileName);
				}
				fileName = dir.GetNext();
			}
			dir.ListDirEnd();
		}
		sounds = soundList.ToArray();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		frame++;
		if (frame % 4 == 0)
		{
			if (((bool)GetNode("..").Get("failed") || (int)GetNode("..").Get("strikes") >= 3) && !hasExploded)
			{
				hasExploded = true;
				foreach (GpuParticles3D child in GetChildren())
				{
					child.Emitting = true;
				}
				GetNode<Node3D>("../bomb_instance").Hide();
				Utils.Logger.Log("test", this);
				SoundManager.PlaySound(sounds[new Random().Next(sounds.Length)]);
			}
		}
	}

/*	public override void _UnhandledInput(InputEvent @event)
	{
		if (@event is InputEventKey keyEvent && keyEvent.Keycode == Key.Space)		{
			foreach (GpuParticles3D child in GetChildren())
			{
				child.Emitting = true;
			}
			GetNode<Node3D>("../bomb_instance").Hide();
		}
	}
	*/
}
