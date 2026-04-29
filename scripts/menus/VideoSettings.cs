using System;
using System.Diagnostics; 
using Godot;
using Godot.Collections;
using static csproject.scripts.core.Utils.Logger;
using static Godot.DisplayServer;

namespace csproject.scripts.menus;

public partial class VideoSettings : Control //TODO: add ui options
{
	
	/*
	 * Expected Types:
	 * Container (which should override this script and thus be skipped)
	 * LineEdit (TextEdit will be treated the same?)
	 * Horizontal Slider
	 * CheckButton
	 * OptionButton
	 * HSeparator
	 */

	[Export] public Dictionary<NodePath, ControlFeatures> Features;
	
	public enum ControlFeatures
	{
		ResolutionW, //linedit
		ResolutionH, //linedit
		// PresetResolution, //OptionButton
		Fullscreen, //optionbutton
		VSync, //optionbutton
		FrameCap, // linedit or optionbutton
		BackButton //button
	}
	
	public enum FullscreenOptions
	{
		Windowed,
		Borderless,
		Fullscreen
	}

	public override void _Ready()
	{
		// base._Ready();
		Log(Features.ToString(), this);
			
		foreach (var (controlNodePath, feature) in Features)
		{
			var controlNode = GetNode(controlNodePath);
			Log($"Feature: {feature}", this);
			Log($"Control: {controlNode}", this);
			switch (feature)
			{
				case ControlFeatures.ResolutionH:
					if (controlNode is LineEdit lineEdit)
					{
						lineEdit.Text = GetWindow().Size.Y + "";
						lineEdit.TextSubmitted += text =>
						{ 
							SetResolution(height: text.ToInt());
							// CallDeferred(nameof(SetResolution), [-1, text.ToInt()]);
						};
						lineEdit.SetMeta("editing", false);
						lineEdit.EditingToggled += editing =>
						{
							lineEdit.SetMeta("editing", editing);
							// if (editing) lineEdit.SetMeta("editValue", lineEdit.Text);
						};
					}
					break;
				case ControlFeatures.ResolutionW:
					if (controlNode is LineEdit lineEdit1)
					{
						lineEdit1.Text = GetWindow().Size.X + "";
						lineEdit1.TextSubmitted += text =>
						{
							SetResolution(text.ToInt());
							// CallDeferred(nameof(SetResolution), [text.ToInt()]);
						}; 
						lineEdit1.SetMeta("editing", false);
						lineEdit1.EditingToggled += editing =>
						{
							lineEdit1.SetMeta("editing", editing);
							// if (editing) lineEdit1.SetMeta("editValue", lineEdit1.Text);
						};
					}
					break;
				case ControlFeatures.Fullscreen:
					if (controlNode is OptionButton fullscreenButton)
					{
						foreach (var fullscreenOption in Enum.GetValues(typeof(FullscreenOptions)))
						{
							fullscreenButton.AddItem(fullscreenOption.ToString());
						}

						fullscreenButton.Text = "Fullscreen Mode";
						fullscreenButton.ItemSelected += index =>
						{
							SetFullscreen((FullscreenOptions)index);
						};
					}

					break;
				case ControlFeatures.VSync:
					if (controlNode is OptionButton vsyncButton)
					{
						foreach (var vsyncMode in Enum.GetValues(typeof(VSyncMode)))
						{
							vsyncButton.AddItem(vsyncMode.ToString());
						}
						vsyncButton.Text = "VSync Mode";
						vsyncButton.ItemSelected += index =>
						{
							SetVSync((VSyncMode)index);
						};
					}
					break;
				case ControlFeatures.FrameCap:
					if (controlNode is LineEdit frameCap)
					{
						//TODO Look at Resolution features for a base (You can use SetFrameCap)
						frameCap.Text = Engine.MaxFps + "";
						frameCap.TextSubmitted += text => { SetFrameCap(text.ToInt()); };
					}
					break;
				case ControlFeatures.BackButton:
					// Log("gack to nmenu " + controlNode.GetType(), this);
					if (controlNode is Godot.Button button)
					{
						// Log("gack to nmenu", this);
						button.Pressed += () =>
						{
							// Log("gack to nmenu", this);
							GetTree().ChangeSceneToFile("res://scenes/menus/Settings.tscn");

						};
					}

					break;
			}
		}
	}

	public override void _Process(double delta)
	{
		base._Process(delta);
		foreach (var (controlNodePath, feature) in Features)
		{
			var controlNode = GetNode(controlNodePath);
			switch (feature)
			{
				case ControlFeatures.ResolutionH:
					if (!controlNode.GetMeta("editing").AsBool())
						((LineEdit)controlNode).Text = GetWindow().Size.Y.ToString();
					break;
				case ControlFeatures.ResolutionW:
					if (!controlNode.GetMeta("editing").AsBool())
						((LineEdit)controlNode).Text = GetWindow().Size.X.ToString();
					break;
			}
		}
	}


	public void SetResolution(int? width = null, int? height = null)
	{
		Log($"Changing res: width? {width != null}", this);
		Window window = GetWindow();
		if (width is null or < 0)
		{
			if (height is null or < 0)
			{
				Log("Can't set resolution with no values",this, LogType.Error);
				throw new Exception();
			}

			Debug.Assert(height != null, nameof(height) + " != null");
			window.Size = new Vector2I(window.Size.X, (int)height);
		}
		else
		{
			Debug.Assert(width != null, nameof(width) + " != null");
			window.Size = new Vector2I((int)width, window.Size.Y);
		}
	}

	public void SetFullscreen(FullscreenOptions mode)
	{
		Log($"fullscreen: {mode.ToString()}", this);
		switch (mode)
		{
			case FullscreenOptions.Windowed:
				GetWindow().Borderless = false;
				GetWindow().Mode = Window.ModeEnum.Windowed;
				GetWindow().Unresizable = false;
				break;
			case FullscreenOptions.Borderless:
				GetWindow().Borderless = true;
				GetWindow().Mode = Window.ModeEnum.Maximized;
				GetWindow().Unresizable = true;
				break;
			case FullscreenOptions.Fullscreen:
				GetWindow().Mode = Window.ModeEnum.ExclusiveFullscreen;
				break;
			default:
				throw new ArgumentOutOfRangeException(nameof(mode), mode, null);
		}
	}

	public static void SetVSync(VSyncMode mode)
	{
		WindowSetVsyncMode(mode);
	}

	public static void SetFrameCap(int frameCap)
	{
		Engine.MaxFps = frameCap;
	}

}
