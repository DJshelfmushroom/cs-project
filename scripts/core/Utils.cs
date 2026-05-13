#define DEBUG 
// #undef DEBUG

using System;
using System.Collections.Generic;
using System.Text;
using Godot;
namespace csproject.scripts.core;

[GlobalClass]
public partial class Utils : Node
{
	
	private static bool _debug = false;
	
	private static readonly string[] LogBlacklist = [""]; // paths that aren't to be logged 
	private static readonly Script SaveManager = ResourceLoader.Load<Script>("res://scripts/core/save_manager.gd");

	private static SceneTree Tree;
	
	public static Script GetSaveManager() => SaveManager;

	public static SceneTree GetSceneTree() => Tree;
	
	public static Node GetNodeFromStatic() => Tree.CurrentScene.GetChild(0);
	
	public static Node GetBombNode(Node caller)
	{
		try
		{
			// Node node = caller.GetTree().CurrentScene.GetNode("Bomb");
			// if (node.Name != "Bomb") throw new Exception();
			// else
			// {
			// 	return node;
			// }
			throw new Exception();
		}
		catch (Exception)
		{
			return caller.GetTree().CurrentScene;
		}
		return caller.GetTree().CurrentScene;
	}

	public static Vector2 InvertVec2(Vector2 vec)
	{
		return new Vector2(vec.Y, vec.X);
	}

	public static class Logger
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
		/// <param name="logType"></param>
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
			
#if DEBUG
			string type = LogTypeLookup[logType];

			//TODO implement path blacklist
			//TODO integrate better with Godot
				
			
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
#endif
		}

		public static void LogGD(string message, Node source)
		{
			Log(message, source);
		}
	}

	public static void LogGD(string message, Node source)
	{
		Logger.LogGD(message, source);
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
#if DEBUG
		_debug = true;
		var debug = new DebugScripts();
		debug.TestColorLogging();
#endif
		Tree = GetTree();
	}

	public override void _Process(double delta)
	{
		SetTree();
	}

	public override void _EnterTree()
	{
		base._EnterTree();
		SetTree();
		CallDeferred(nameof(SetTree));
	}

	private void SetTree()
	{
		Tree = GetTree();
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

	public override void _UnhandledInput(InputEvent @event)
	{
		base._UnhandledInput(@event);
		DebugFeatures.hotkey(@event);
	}

	static class DebugFeatures
	{
		private const string LogMessage = "DebugFeatures";

		static Script SaveManager = ResourceLoader.Load<Script>("res://scripts/core/save_manager.gd");
		static void AddXp(int amount)
		{
			SaveManager.Set("totalxp", (int) SaveManager.Get("totalxp") + amount);
			Logger.Log($"giving {amount} xp, total: {SaveManager.Get("totalxp")}", LogMessage, Logger.LogType.Debug, Logger.LogColors.GREEN);
			
		}

		public static void hotkey(InputEvent @event)
		{
			if (@event.IsActionPressed("debug_hotkey_1")){
				AddXp(100);
				Logger.Log("hotkey worked", LogMessage, Logger.LogType.Debug, Logger.LogColors.GREEN);
			}
		}
	}
	
}
