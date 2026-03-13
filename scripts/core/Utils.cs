using System;
using System.Collections.Generic;
using System.Text;
using Godot;

namespace csproject.scripts.core;

[GlobalClass]
public partial class Utils : Node
{
	private static bool _debug = true;
	private static readonly string[] LogBlacklist = [""]; // paths that aren't to be logged 

	public class Logger
	{
		public enum LogType
		{
			Debug,
			Error,
			Warning
		}

		public enum LogColors
		{
			RED,
			YELLOW,
			ORANGE,
			GREEN,
			BlUE,
			WHITE
		}

		// private static readonly Dictionary<TextColor, string> TextColorLookup = new Dictionary<TextColor, string>()
		// {
		// 	{
		// 		TextColor.RED, nameof(TextColor.RED)
		// 	}
		// };

		private static string GetLogColorString(LogColors logColors)
		{
			string color = logColors.ToString().ToLower();
			return color;
		}

		private static readonly Dictionary<LogType, string> LogTypeLookup = new Dictionary<LogType, string>()
		{
			{
				LogType.Debug, "DEBUG"
			},
			{
				LogType.Error, "ERROR"
			},
			{
				LogType.Warning, "WARNING"
			}
		};

		private static readonly Dictionary<LogType, LogColors> LogColorLookup = new Dictionary<LogType, LogColors>()
		{
			{
				LogType.Debug, LogColors.YELLOW
			},
			{
				LogType.Error, LogColors.RED
			},
			{
				LogType.Warning, LogColors.ORANGE
			}
		};

		/// <summary>
		/// Prints a formatted string for debugging (future plans: error/warning/debug, more options for not sending).
		/// Please use this instead of GD.Print.
		/// </summary>
		/// <param name="message">The string to print</param>
		/// <param name="source">Should be `this` (.NET) or `self` (gdscript) in most cases. Just used for name. Set to null for `General`</param>
		/// <param name="type">Use if you want a different note `Debug` by default</param>
		/// <param name="color">Change the color of the message with BBCode format (eg. "yellow", "red")</param>
		public static void Log(string message, Node source, LogType logType = LogType.Debug,
			LogColors color = LogColors.YELLOW)
		{
			Log(message, source.GetPath().ToString().Substring(6), logType, color);
		}

		// prefer not to use, but it works
		public static void Log(string message, string source, LogType logType = LogType.Debug,
			LogColors color = LogColors.YELLOW)
		{
			string type = LogTypeLookup[logType];

			//TODO implement path blacklist
			//TODO integrate better with Godot
			if (!_debug) return;
			StringBuilder output = new StringBuilder();
			output.Append($"[{type}@");
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
				color = LogColors.RED;
			}

			GD.PrintRich("[color=" + GetLogColorString(color) + "]", output.ToString(), "[/color]");
		}

		public static void LogGD(string message, Node source)
		{
			Log(message, source);
		}
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
				Logger.Log("Please use a valid CursorState!", "Utils.SetCursor call", Logger.LogType.Error);
				throw new NotImplementedException();
		}
	}

	public override void _Ready()
	{
		if (!_debug) return;
		var debug = new DebugScripts();
		debug.TestColorLogging();
	}
	class DebugScripts
	{
		private const string LogMessage = "DebugScript";
		public void TestColorLogging()
		{
			Logger.Log("This is a debug message", LogMessage, Logger.LogType.Debug, Logger.LogColors.YELLOW);
			Logger.Log("This is an error message", LogMessage, Logger.LogType.Error, Logger.LogColors.RED);
			Logger.Log("This is a warning message", LogMessage, Logger.LogType.Warning, Logger.LogColors.ORANGE);
		}
	}
}



