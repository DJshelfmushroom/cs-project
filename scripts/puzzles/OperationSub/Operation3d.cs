//#define CAMERA
using Godot;
using System;

public partial class Operation3d : Node3D
{
	//public static int id = 14;
	//public static bool completed = false;
	#if !CAMERA
	public override void _Ready()
	{
		// var camera = new Camera3D();
		// AddChild(camera);
		foreach (var child in GetChildren())
		{
			if (child is Camera3D)
			{
				RemoveChild(child);
			}
		}
	}
	#endif
}
