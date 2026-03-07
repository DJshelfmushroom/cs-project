using System;
using System.Text;
using Godot;

namespace csproject.scripts.core;

[GlobalClass]
public partial class Utils : Node
{
	private static bool _debug = true;
	private static readonly string[] LogBlacklist = [""]; // paths that aren't to be logged 

	/// <summary>
	/// Prints a formatted string for debugging (future plans: error/warning/debug, more options for not sending).
	/// Please use this instead of GD.Print.
	/// </summary>
	/// <param name="message">The string to print</param>
	/// <param name="source">Should be `this` (.NET) or `self` (gdscript) in most cases. Just used for name. Set to null for `General`</param>
	/// <param name="type">Use if you want a different note `Debug` by default</param>
	/// <param name="color">Change the color of the message with BBCode format (eg. "yellow", "red")</param>
	public static void Log(string message, Node source, string type = "DEBUG", string color = "yellow")
	{
		Log(message, source.GetPath().ToString().Substring(6), type, color);
	}

	// prefer not to use, but it works
	public static void Log(string message, string source, string type = "DEBUG", string color = "yellow")
	{
		//TODO implement path blacklist
		//TODO integrate better with Godot
		if (!_debug) return;
		StringBuilder output = new StringBuilder();
		output.Append($"[{type}@ ");
		if (source == null)
		{
			output.Append("General");
		}
		else
		{
			output.Append(source);
		}

		output.Append("]: ");
		output.Append(message);
		if (type == "ERROR")
		{
			color = "red";
		}

		GD.PrintRich("[color=" + color + "]",output.ToString(), "[/color]");
	}

	public static void LogGD(string message, Node source)
	{
		Log(message, source);
	}

	/// <summary>
	/// 
	/// </summary>
	/// <returns>Whether or not the game is in debug mode, logging debug messages</returns>
	public static bool GetDebug()
	{
		return _debug;
	}

	public enum CursorState
	{
		Arrow,
		Hand
	}
	
	/// <summary>
	/// A quick and simplified way to set the cursor shape
	/// </summary>
	/// <param name="state">the state of the cursor (currently: Arrow or "Hand," which is the pointing hand)</param>
	/// <exception cref="NotImplementedException">Used when the state parameter is not an option here</exception>
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
			default:
				Log("Please use a valid CursorState!", "Utils.SetCursor call", "ERROR");
				throw new NotImplementedException();
		}
	}
	
}
