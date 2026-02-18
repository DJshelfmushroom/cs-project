using System;
using System.Linq.Expressions;
using Godot;
using v3 = Godot.Vector3;
using dd3d = DebugDraw3D;

public partial class CameraControl : Camera3D
{
	private static readonly Action<String> log = Godot.GD.Print;
	public void Zoom(float amount)
	{
		// 3 methods:
		// amount, min, max. change fov for zoom
		// this.Fov = Mathf.Clamp(this.Fov + amount, -500, 120);
		// Move towards forward
		//Transform = Transform.Translated(Vector3.ModelLeft * amount);
		// Move towards bomb
		var bomb = GetNode<Node3D>("../bomb_instance");
		v3 direction = (bomb.GlobalPosition - this.GlobalPosition).Normalized();
		float distToBomb = (bomb.GlobalPosition - this.GlobalPosition).Length();
		var ray = new RayCast3D();
		ray.Enabled = true;
		AddChild(ray);
		ray.GlobalPosition = this.GlobalPosition;
		// ensure the ray will detect both bodies and areas and check all layers while debugging
		ray.CollideWithBodies = true;
		//ray.CollideWithAreas = true;
		ray.CollisionMask = uint.MaxValue;

		// TargetPosition is local to the RayCast node, so set it to the vector from the ray origin to the bomb
		ray.TargetPosition = bomb.GlobalPosition - ray.GlobalPosition;
		ray.ForceRaycastUpdate();
		dd3d.DrawLine(ray.GlobalPosition, bomb.GlobalPosition, Colors.Green, 1f);
		if (ray.IsColliding())
		{
			v3 point = ray.GetCollisionPoint();
			float distToColPoint = (point - this.GlobalPosition).Length();
			log("😭" + point);
			DebugDraw3D.DrawPoints([point], DebugDraw3D.PointType.TypeSphere, 0.01f, Colors.Red, (float)base.GetProcessDeltaTime());
			if (amount < 0 && distToColPoint <= 0.1f)
			{
				ray.QueueFree();
				return;
			}
		}
		// Don't let the camera zoom closer than this distance to the bomb
		/*
		if (amount < 0 && distToBomb <= 0.6f)
		{
			return;
		}
		*/
		Transform = Transform.Translated(direction * -amount);
		ray.QueueFree();

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