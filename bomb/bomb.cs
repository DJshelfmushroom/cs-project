using Godot;
using System;
using System.Collections.Generic;


public partial class bomb : Node3D
{
	PackedScene plug_scene = GD.Load<PackedScene>("res://bomb/plug.tscn");


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
			Node3D plugMesh = (Node3D)plug_scene.Instantiate();
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
		
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		if (@event is InputEventMouseMotion motion)
		{
			if (Input.IsActionPressed("ui_mouse_right_button"))
			{
				MouseWrap(motion);
			}
		}
	}

	private void MouseWrap(InputEventMouseMotion motion)
	{
		var transform = this.Transform;
		transform.Basis = transform.Basis.Rotated(Vector3.Up, motion.Relative.X * 0.01f);
		transform.Basis = transform.Basis.Rotated(Vector3.Forward, motion.Relative.Y * 0.01f);
		this.Transform = transform;
		Vector2 mousePos = GetViewport().GetMousePosition();
		float delta = (float)GetProcessDeltaTime();
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
}
