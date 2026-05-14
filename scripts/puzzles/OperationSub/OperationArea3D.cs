using System.Dynamic;
using System.Threading.Tasks;
using csproject.scripts.core;
using Godot;
using static csproject.scripts.puzzles.OperationSub.OperationArea2D.Section;
using static csproject.scripts.core.Utils.Logger;

namespace csproject.scripts.puzzles.OperationSub;

public partial class OperationArea3D(OperationArea2D.Section section) : Area3D
{
	private static short _intersections = 0;
	private Operation _operation;
	private static bool _playing = false;
	private Color color;
	
	public Color GetColor()
	{
		return color;
	}
	public void SetColor(Color color) 
	{
		this.color = color;
	}
	
	public override void _Ready()
	{
		base._Ready();
		Node parent = this;
		do
		{
			parent = parent.GetParent();
		} while (!(parent is Operation || parent is Window));
		_operation = (Operation)parent;
		if (_operation == null)
		{
			QueueFree();
		}
		
	}

	/*
	public override void _UnhandledInput(InputEvent @event)
	{
		base._UnhandledInput(@event);
		if (@event is InputEventMouse mouseEvent)
		{
			if (mouseEvent.IsActionPressed("ui_mouse_left_button") && _intersections > 0)
			{
				Strike();
				Utils.SetCursor(Utils.CursorState.Hand);
			}
			else
			{
				Utils.SetCursor(Utils.CursorState.Arrow);
			}
		}
	}
	*/

	public override void _UnhandledInput(InputEvent @event)
	{
		base._UnhandledInput(@event);
		if (@event is InputEventMouse mouseEvent)
		{
			if (mouseEvent.IsActionPressed("ui_mouse_left_button") && _intersections > 0)
			{
				
			}
		}
	}

	public override void _MouseEnter()
	{
		//base._MouseEnter();
		// Log("1", _operation);
		_intersections++;
		
		if (!Input.IsActionPressed("ui_mouse_left_button")/* && !section.Equals(First) */)
		{
			_playing = false;
			return;
		}
		Log($"Intersections: {_intersections}, Section: {section}, {_playing} | enter", _operation);
		// Log("2", _operation);
		
		if (_intersections == 1 && !section.Equals(First) && !_playing)
		{
			Strike();
		}
		else if (section.Equals(First))
		{
			// Log("3", _operation);
			Utils.SetCursor(Utils.CursorState.Hand);
			_playing = true;
		}
	}

	public override void _MouseExit()
	{
		//base._MouseExit();
		// Log("1e", _operation);
		_intersections--;
		
		if (!Input.IsActionPressed("ui_mouse_left_button"))
		{
			if (_playing)
			{
				Strike();
			}

			return;
		}
		Log($"Intersections: {_intersections}, Section: {section}, {_playing} | exit", _operation);
		// Log("2e", _operation);
	   
		if (section.Equals(Last) && _playing)
		{
			Log("vic", _operation);
			_operation.Success();
		} else if (_intersections == 0 && !section.Equals(First))
		{
			CallDeferred(nameof(CheckLos));
		}
	}

	private void CheckLos()
	{
		if (_intersections == 0 && _playing)
		{
			Log("los", _operation);
			CallDeferred(nameof(Strike));
		}
	}

	private void Strike()
	{
		Utils.SetCursor(Utils.CursorState.Arrow);
		if (_playing && _intersections == 0) _operation.Failure();
		_playing = false;
		Utils.SetCursor(Utils.CursorState.Arrow);
	}
}
