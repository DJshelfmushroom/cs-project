using Godot;
using Utils = csproject.scripts.core.Utils;

namespace csproject.scripts.ui.roltateAxis;

public partial class Side : Area3D
{
	private bool _mouseOver = false;
	private CollisionShape3D _shape;
	private static StringName _lookAtName;
	
	public override void _Input(InputEvent @event)
	{
		base._Input(@event);
		if (@event is InputEventMouseButton mouseButtonEvent && mouseButtonEvent.Pressed && mouseButtonEvent.ButtonIndex == MouseButton.Left && _mouseOver)
		{
			GetParent().Call(_lookAtName, _shape);
		}
	}

	public override void _Ready()
	{
		_lookAtName = Roltateaxis.GetLookAtMethodName();
	}
	

	public void SetShape(CollisionShape3D shape)
	{
		_shape = shape;
	}

	public override void _MouseEnter() // would like to note that the cursor hitbox is a little wierd
	{
		base._MouseEnter();
		_mouseOver = true;
		Utils.SetCursor(Utils.CursorState.Hand);
	}

	public override void _MouseExit()
	{
		base._MouseExit();
		_mouseOver = false;
		Utils.SetCursor(Utils.CursorState.Arrow);
	}
}