using Godot;
using System;
using System.Collections.Generic;


public partial class bomb : Node3D
{
	PackedScene _plugScene = GD.Load<PackedScene>("res://bomb/plug.tscn");
		enum LockedAxes { X, Y, Z, None};
		LockedAxes LockedAxis = LockedAxes.None;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		make_plugs();
	}

	// makes plugs at the plug locations
	private void make_plugs()
	{
		for (int i = 0; i < GetNode<Node>("../PlugLocs").GetChildCount(); i++)
		{
			// instantiate plug
			Node3D plugMesh = (Node3D)_plugScene.Instantiate();
			this.AddChild(plugMesh);
			// dear god this is horrendous
			plugMesh.GlobalPosition = ((Node3D)GetNode<Node3D>("../PlugLocs").GetChildren()[i]).GlobalPosition;
			
			RayCast3D ray = plugMesh.GetNode("RayCast3D") as RayCast3D;
			ray.Enabled = true;
			// set target position in local space
			ray.TargetPosition = ray.ToLocal((this as Node3D)/*this is worse lol*/.GlobalPosition);
			ray.ForceRaycastUpdate();

			if (ray.IsColliding())
			{
				// Normal of the collision point
				Vector3 normal = ray.GetCollisionNormal().Normalized();
				var collisionPoint = ray.GetCollisionPoint();
				// Set the plug's position to the collision point (and rotate it to face outwards)
				plugMesh.LookAt(collisionPoint + normal, plugMesh.Transform.Basis.Z);
				plugMesh.GlobalPosition = collisionPoint;
			}
		}
	}
	
	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		switch (LockedAxis)
		{
			case LockedAxes.X:
				DebugDraw3D.DrawLine(Vector3.Left * 10, Vector3.Right * 10, Colors.Red);
				break;
			case LockedAxes.Y:
				DebugDraw3D.DrawLine(Vector3.Down * 10, Vector3.Up * 10, Colors.Green);
				break;
			case LockedAxes.Z:
				DebugDraw3D.DrawLine(Vector3.Back * 10, Vector3.Forward * 10, Colors.Blue);
				break;
			default:
				break;
		}
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		if (@event is InputEventMouseMotion motion)
		{
			if (Input.IsActionPressed("ui_mouse_right_button"))
			{
				MouseWrap(motion);
				RotateBomb(motion);
			}
		} else if (@event is InputEventKey keyEvent)
		{
			if (keyEvent.IsActionPressed("key_x"))
			{
				LockedAxis = LockedAxis == LockedAxes.X ? LockedAxes.None : LockedAxes.X;
			}
			else if (keyEvent.IsActionPressed("key_y"))
			{
				LockedAxis = LockedAxis == LockedAxes.Y ? LockedAxes.None : LockedAxes.Y;
			}
			else if (keyEvent.IsActionPressed("key_z"))
			{
				LockedAxis = LockedAxis == LockedAxes.Z ? LockedAxes.None : LockedAxes.Z;
			}
		}
	}

	private void MouseWrap(InputEventMouseMotion motion)
	{
		Vector2 mousePos = GetViewport().GetMousePosition();
		Vector2 mouseVel = motion.Relative;
		Vector2 size = GetViewport().GetVisibleRect().Size;
		int wrapTolerance = 32;
		int velTolerance = 4;

		if (mousePos.X + mouseVel.X > size.X)
		{
			Input.WarpMouse(new Vector2(mouseVel.X, mousePos.Y));
		}
		else if (mousePos.X + mouseVel.X < 0)
		{
			Input.WarpMouse(new Vector2(size.X + mouseVel.X, mousePos.Y));
		}
		else if (mousePos.Y + mouseVel.Y > size.Y)
		{
			Input.WarpMouse(new Vector2(mousePos.X, mouseVel.Y));
		}
		else if (mousePos.Y + mouseVel.Y < 0)
		{
			Input.WarpMouse(new Vector2(mousePos.X, size.Y + mouseVel.Y));
		}
	}

	private void RotateBomb(InputEventMouseMotion motion)
	{
		var transform = this.Transform;
		var sensitivity = 0.01f;
    
		if (LockedAxis != LockedAxes.None)
		{
			// Single axis lock: map mouse to the locked axis
			Vector3 axis;
			switch (LockedAxis)
			{
				case LockedAxes.X: axis = Vector3.Right; break;
				case LockedAxes.Y: axis = Vector3.Up; break;
				case LockedAxes.Z: axis = Vector3.Forward; break;
				default: return;
			}
			// Use combined mouse delta for free motion on locked axis (Blender-like)
			float angle = (motion.Relative.X + motion.Relative.Y) * sensitivity;
			transform.Basis = transform.Basis.Rotated(axis, angle);
		}
		else
		{
			// Free rotation: yaw on Up, pitch on Forward (your original)
			transform.Basis = transform.Basis.Rotated(Vector3.Up, motion.Relative.X * sensitivity);
			transform.Basis = transform.Basis.Rotated(Vector3.Forward, motion.Relative.Y * sensitivity);
		}
    
		this.Transform = transform;
	}
}
