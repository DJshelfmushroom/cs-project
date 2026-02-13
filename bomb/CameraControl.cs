using Godot;

public partial class CameraControl : Camera3D
{
	public void Zoom(float amount)
	{
		// 3 methods:
		// amount, min, max. change fov for zoom
		// this.Fov = Mathf.Clamp(this.Fov + amount, -500, 120);
		// Move towards forward
		//Transform = Transform.Translated(Vector3.ModelLeft * amount);
		// Move toward bomb
		var bomb = GetNode<Node3D>("../bomb_instance");
		Vector3 direction = (bomb.GlobalPosition - this.GlobalPosition).Normalized();
		float distToBomb = (bomb.GlobalPosition - this.GlobalPosition).Length();

		// Don't let the camera zoom closer than this distance to the bomb
		if (amount < 0 && distToBomb <= 0.6f)
		{
			return;
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