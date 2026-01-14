using Godot;
using System;

public partial class Roltateaxis : Node3D
{
	public override void _Process(double delta)
	{
		base._Process(delta);
		try
		{
			Vector3 bombRotation = (Vector3) GetNode("../../bomb_instance").Call("GetBombRotation");
			GlobalRotation = bombRotation;
		}
		catch (Exception _) // what is type cast exception
		{
			return;
		}
	}
	
}
