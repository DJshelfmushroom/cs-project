using System;
using System.Diagnostics;
using System.Linq.Expressions;
using Godot;
using Godot.Collections;
using v3 = Godot.Vector3;
using dd3d = DebugDraw3D;

public partial class CameraControl : Camera3D
{
	private static readonly Action<String> log = Godot.GD.Print;
	public void Zoom(float amount)
	{
		Node3D bomb = GetNode<Node3D>("../bomb_instance");
		v3 direction = (bomb.GlobalPosition - this.GlobalPosition).Normalized();

		PhysicsDirectSpaceState3D spaceState = GetWorld3D().DirectSpaceState;
		PhysicsRayQueryParameters3D query = PhysicsRayQueryParameters3D.Create(
			this.GlobalPosition,
			bomb.GlobalPosition,
			collisionMask: uint.MaxValue
		);
		query.CollideWithBodies = true;

		Dictionary result = spaceState.IntersectRay(query);

		if (result.Count > 0)
		{
			v3 point = (v3)result["position"];
			float distToColPoint = (point - this.GlobalPosition).Length();

			// prevent zooming in past the collision point
			if (amount < 0 && distToColPoint <= 0.1f)
			{
				return;
			}
		}

		Transform = Transform.Translated(direction * -amount);
	}

	public void Pan(float x, float y)
	{
		// pan the camera by moving it along its local axes
		this.TranslateObjectLocal(new Vector3(x, y, 0));
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		if (@event is InputEventMouseMotion motion)
		{
			if (Input.IsActionPressed("cam_pan_mod"))
			{
				Pan(-motion.Relative.X * 0.01f, motion.Relative.Y * 0.01f);
			}
		}
		else if (@event is InputEventMouseButton buttonEvent)
		{
			if (buttonEvent.ButtonIndex == MouseButton.WheelUp && buttonEvent.Pressed)
			{
				Zoom(-0.05f);
			}
			else if (buttonEvent.ButtonIndex == MouseButton.WheelDown && buttonEvent.Pressed)
			{
				Zoom(0.05f);
			}
		}
	}
}
