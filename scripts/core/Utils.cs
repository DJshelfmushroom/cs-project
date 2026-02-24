using System;
using System.Text;
using Godot;

namespace csproject.scripts.core;

[GlobalClass]
public partial class Utils : Node
{
	private static readonly bool Debug = true;
	
	/// <summary>
	/// Prints a formatted string for debugging (future plans: error/warning/debug, more options for not sending).
	/// Please use this instead of GD.Print.
	/// </summary>
	/// <param name="message">The string to print</param>
	/// <param name="source">Should be `this` (.NET) or `self` (gdscript) in most cases. Just used for name. Set to null for `General`</param>
	/// <param name="type">Use if you want a different note `Debug` by default</param>
	public static void Log(string message, Node source, string type = "Debug") 
	{
		if (!Debug) return;
		StringBuilder output = new StringBuilder();
		output.Append($"[{type}/");
		if (source == null)
		{
			output.Append("General");
		}
		else
		{
			output.Append(source.GetName());
		}
		output.Append("]: ");
		output.Append(message);

		GD.Print(output.ToString());
	}

	public static void LogGD(string message, Node source)
	{
		Log(message, source);
	}


	public static bool GetDebug()
	{
		return Debug;
	}

	public enum CursorState
	{
		Arrow,
		Hand
	}
	
	public static void SetCursor(CursorState state)
	{
		switch (state)
		{
			case CursorState.Arrow:
				Input.SetDefaultCursorShape(Input.CursorShape.Arrow);
				break;
			case CursorState.Hand:
				Input.SetDefaultCursorShape(Input.CursorShape.PointingHand);
				break;
		}
	}
}

// public partial class Util : Node
// {
// 	public override void _Ready()
// 	{
// 		
// 	}
//
// 	public override void _Process(double delta)
// 	{
// 		base._Process(delta);
// 	}
//
// 	public override void _Input(InputEvent @event)
// 	{
// 	}
// 	
// }
