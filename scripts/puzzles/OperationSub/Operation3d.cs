#define CAMERA
using Godot;
using System;

public partial class Operation3d : Node3D
{
	public static bool completed = false;
	#if CAMERA
	public override void _Ready()
	{
		// var camera = new Camera3D();
		// AddChild(camera);
	}
	#endif
}
