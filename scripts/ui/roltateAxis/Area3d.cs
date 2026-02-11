using Godot;
using System;

public partial class Area3d : Area3D
{
	bool mouseOver = false;
	public override void _Input(InputEvent @event)
	 {
		base._Input(@event);
		if (@event is InputEventMouseButton mouseButtonEvent && mouseButtonEvent.Pressed && mouseButtonEvent.ButtonIndex == MouseButton.Left && mouseOver)
		{
			GD.Print("Left mouse button pressed on Area3D " + Name);
		}
	 }

	public override void _MouseEnter()
	{
		base._MouseEnter();
		mouseOver = true;
	}

	public override void _MouseExit()
	{
		base._MouseExit();
		mouseOver = false;
	}
}
