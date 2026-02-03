using Godot;

public partial class bomb : Node3D
{
	private PackedScene _plugScene = GD.Load<PackedScene>("res://bomb/plug.tscn");

	private enum LockedAxes
	{
		X,
		Y,
		Z,
		None
	}

	private LockedAxes LockedAxis = LockedAxes.None;
	private bool _suppressRotationOnce;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		InstanceUtils.MakeInstances(this, _plugScene);
	}

	// plug instantiation/placement moved to bomb/plug_utils.cs (PlugUtils.MakePlugs)

	public override void _Process(double delta)
	{
		//TODO: custom axis draw?
		switch (LockedAxis)
		{
			// draw the locked axis line
			case LockedAxes.X:
				DebugDraw3D.DrawLine(Vector3.Left * 10, Vector3.Right * 10, Colors.Red);
				break;
			case LockedAxes.Y:
				DebugDraw3D.DrawLine(Vector3.Down * 10, Vector3.Up * 10, Colors.Green);
				break;
			case LockedAxes.Z:
				DebugDraw3D.DrawLine(Vector3.Back * 10, Vector3.Forward * 10, Colors.Blue);
				break;
		}
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		if (@event is InputEventMouseMotion motion)
		{
			if (Input.IsActionPressed("ui_mouse_right_button"))
			{
				var wrapped = MouseWrap(motion);
				if (_suppressRotationOnce)
				{
					_suppressRotationOnce = wrapped;
					return;
				}

				if (wrapped)
				{
					_suppressRotationOnce = true;
					return;
				}

				RotateBomb(motion);
			}
		}
		else if (@event is InputEventKey keyEvent)
		{
			// check what key, and lock that axis
			if (keyEvent.IsActionPressed("key_x"))
				LockedAxis = LockedAxis == LockedAxes.X ? LockedAxes.None : LockedAxes.X;
			else if (keyEvent.IsActionPressed("key_y"))
				LockedAxis = LockedAxis == LockedAxes.Y ? LockedAxes.None : LockedAxes.Y;
			else if (keyEvent.IsActionPressed("key_z"))
				LockedAxis = LockedAxis == LockedAxes.Z ? LockedAxes.None : LockedAxes.Z;
		}
	}


	public Vector3 GetBombRotation()
	{
		return Rotation;
	}

	private bool MouseWrap(InputEventMouseMotion motion)
	{
		// get the mouse position and velocity
		var mousePos = GetViewport().GetMousePosition();
		var mouseVel = motion.Relative;
		var size = GetViewport().GetVisibleRect().Size;
		// we have not wrapped yet, this is for the mouse wrap logic
		var wrapped = false;

		// detect which edge to wrap on
		if (mousePos.X + mouseVel.X > size.X)
		{
			Input.WarpMouse(new Vector2(mouseVel.X, mousePos.Y));
			wrapped = true;
		}
		else if (mousePos.X + mouseVel.X < 0)
		{
			Input.WarpMouse(new Vector2(size.X + mouseVel.X, mousePos.Y));
			wrapped = true;
		}
		else if (mousePos.Y + mouseVel.Y > size.Y)
		{
			Input.WarpMouse(new Vector2(mousePos.X, mouseVel.Y));
			wrapped = true;
		}
		else if (mousePos.Y + mouseVel.Y < 0)
		{
			Input.WarpMouse(new Vector2(mousePos.X, size.Y + mouseVel.Y));
			wrapped = true;
		}

		return wrapped;
	}

	private void RotateBomb(InputEventMouseMotion motion)
	{
		var transform = Transform;
		var sensitivity = 0.01f;

		if (LockedAxis != LockedAxes.None)
		{
			Vector3 axis;
			switch (LockedAxis)
			{
				case LockedAxes.X:
					axis = Vector3.Right;
					break;
				case LockedAxes.Y:
					axis = Vector3.Up;
					break;
				case LockedAxes.Z:
					axis = Vector3.Forward;
					break;
				default: return;
			}

			var angle = (motion.Relative.X + motion.Relative.Y) * sensitivity;
			transform.Basis = transform.Basis.Rotated(axis, angle).Orthonormalized();
		}
		else
		{
			transform.Basis = transform.Basis.Rotated(Vector3.Up, motion.Relative.X * sensitivity);
			transform.Basis = transform.Basis.Rotated(Vector3.Forward, motion.Relative.Y * sensitivity);
			transform.Basis = transform.Basis.Orthonormalized();
		}

		Transform = transform;
	}}
