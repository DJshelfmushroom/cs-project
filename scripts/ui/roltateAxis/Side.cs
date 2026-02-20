using Godot;
using System;

public partial class Side : Area3D
{
	private bool MouseOver = false;
	private CollisionShape3D _shape;
	// private int direction;
	private static StringName _lookAtName;
	public override void _Input(InputEvent @event)
	 {
		base._Input(@event);
		if (@event is InputEventMouseButton mouseButtonEvent && mouseButtonEvent.Pressed && mouseButtonEvent.ButtonIndex == MouseButton.Left && MouseOver)
		{
			GD.Print("Left mouse button pressed on Area3D " + Name);
			GD.Print(Position.ToString());
			GetParent().Call(_lookAtName, _shape);
		}
	 }

	public override void _Ready()
	{
		_lookAtName = Roltateaxis.GetLookAtMethodName();
	}

	public void SetShape(CollisionShape3D shape)
	{
		this._shape = shape;
	}

	public override void _MouseEnter()
	{
		base._MouseEnter();
		MouseOver = true;
	}

	public override void _MouseExit()
	{
		base._MouseExit();
		MouseOver = false;
	}
}
