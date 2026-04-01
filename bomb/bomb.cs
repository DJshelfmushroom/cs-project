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
		Node3D gamesNode = GetNode<Node3D>("./Games");
		InstanceUtils.MakeInstances(this, _plugScene);
		var ray = new RayCast3D();
		ray.Enabled = true;
		AddChild(ray);
		
		for (int i = 0; i < gamesNode.GetChildCount(); i++)
		{
			var child = gamesNode.GetChild(i) as Node3D;
			if (child == null) continue;

			var from = child.GlobalPosition;
			var to = this.GlobalPosition;
			ray.GlobalPosition = from;
			ray.TargetPosition = to - from;
			ray.ForceRaycastUpdate();
			if (ray.IsColliding())
			{
				child.GlobalPosition = ray.GetCollisionPoint() + ray.GetCollisionNormal() * 0.0105f;
			}
		}
		ray.QueueFree();
		Position = new Vector3(0, 0.667f, 0); // idk how else to do it tbh - more in roltateaxis.cs
	}

	// plug instantiation/placement moved to bomb/instance_utils.cs (InstanceUtils.MakeInstances)

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

	private void RotateBomb(InputEventMouseMotion motion, bool force = false)
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

		var camera = GetNode<Camera3D>("../Camera3D");
		Aabb localAabb = GetMergedLocalAabb();

		Vector3 dir = (camera.GlobalPosition - GlobalPosition).Normalized();
		Vector3 localDir = GlobalTransform.Basis.Inverse() * dir;

		float exitDist = RayAabbExitDistance(localAabb, Vector3.Zero, localDir);
		float minDist = exitDist + camera.Near * 3f;

		float currentDist = (camera.GlobalPosition - GlobalPosition).Length();
		if (currentDist < minDist)
			camera.GlobalPosition = GlobalPosition + dir * minDist;
	}

	public float GetMinCameraDistance(Vector3 worldDir)
	{
		Aabb localAabb = GetMergedLocalAabb();
		Vector3 localDir = GlobalTransform.Basis.Inverse() * worldDir;
		return RayAabbExitDistance(localAabb, Vector3.Zero, localDir);
	}

	private Aabb GetMergedLocalAabb()
	{
		Aabb merged = new Aabb();
		bool first = true;
		foreach (Node child in GetChildren())
		{
			if (child is VisualInstance3D visual)
			{
				// Transform each child's AABB into this node's local space
				Aabb childAabb = TransformAabb(visual.GetAabb(), (child as Node3D).Transform);
				merged = first ? childAabb : merged.Merge(childAabb);
				first = false;
			}
		}
		return merged;
	}

	private static Aabb TransformAabb(Aabb aabb, Transform3D t)
	{
		Vector3 mn = aabb.Position, mx = aabb.End;
		Vector3[] corners = {
			t * new Vector3(mn.X, mn.Y, mn.Z), t * new Vector3(mx.X, mn.Y, mn.Z),
			t * new Vector3(mn.X, mx.Y, mn.Z), t * new Vector3(mx.X, mx.Y, mn.Z),
			t * new Vector3(mn.X, mn.Y, mx.Z), t * new Vector3(mx.X, mn.Y, mx.Z),
			t * new Vector3(mn.X, mx.Y, mx.Z), t * new Vector3(mx.X, mx.Y, mx.Z),
		};
		Vector3 newMin = corners[0], newMax = corners[0];
		for (int i = 1; i < 8; i++) { newMin = newMin.Min(corners[i]); newMax = newMax.Max(corners[i]); }
		return new Aabb(newMin, newMax - newMin);
	}

	/// <summary>
	/// Computes the distance along a ray from <paramref name="origin"/> in direction <paramref name="dir"/>
	/// to the exit point (the far intersection) with an axis-aligned bounding box.
	/// </summary>
	/// <param name="box">Axis-aligned bounding box. <see langword="box.Position"/> is treated as the minimum corner and <see langword="box.End"/> as the maximum corner.</param>
	/// <param name="origin">The ray origin, in the same coordinate space as <paramref name="box"/>.</param>
	/// <param name="dir">The ray direction vector. The vector is not required to be normalized. Components with absolute value less than 1e-6 are treated as parallel to the corresponding axis.</param>
	private static float RayAabbExitDistance(Aabb box, Vector3 origin, Vector3 dir)
	{
		Vector3 mn = box.Position, mx = box.End;
		float tMin = float.NegativeInfinity, tMax = float.PositiveInfinity;
		for (int i = 0; i < 3; i++)
		{
			if (Mathf.Abs(dir[i]) < 1e-6f)
			{
				if (origin[i] < mn[i] || origin[i] > mx[i]) return 0f;
				continue;
			}
			float t1 = (mn[i] - origin[i]) / dir[i];
			float t2 = (mx[i] - origin[i]) / dir[i];
			if (t1 > t2) { float tmp = t1; t1 = t2; t2 = tmp; }
			tMin = Mathf.Max(tMin, t1);
			tMax = Mathf.Min(tMax, t2);
		}
		if (tMax < 0f || tMin > tMax) return 0f;
		return tMax; // far intersection — the exit face
	}
	
}
