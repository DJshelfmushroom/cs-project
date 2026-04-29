using Godot;
using System;
using System.Collections.Generic;

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
				if (!dir.CurrentIsDir() && !fileName.StartsWith("."))
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
				AudioStreamPlayer explosionSound = new AudioStreamPlayer();
				GetNode<Node3D>("../bomb_instance").Hide();
				explosionSound.Stream = GD.Load<AudioStreamWav>(sounds[new Random().Next(sounds.Length)]);
				GetParent().AddChild(explosionSound);
				explosionSound.Play();
				explosionSound.Connect("finished", Callable.From(() => explosionSound.QueueFree()));
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
