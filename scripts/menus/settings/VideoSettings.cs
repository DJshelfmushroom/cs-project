using System;
using System.Diagnostics;
using csproject.scripts.core;
using Godot;
using Godot.Collections;
using static csproject.scripts.core.Utils.Logger;
using static Godot.DisplayServer;

namespace csproject.scripts.menus.settings;

[GlobalClass]
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

	[Export] private Dictionary<NodePath, ControlFeatures> Features;

	private enum ControlFeatures // add stretch mode? (would have to change the mouse cursor changing part maybe [or it uses the viewport? idk])
	{
		ResolutionW, //linedit
		ResolutionH, //linedit
		// PresetResolution, //OptionButton
		Fullscreen, //optionbutton
		VSync, //optionbutton
		FrameCap, // linedit or optionbutton
		BackButton, //button
		ApplyButton //button
	}

	public enum FullscreenOptions
	{
		Windowed,
		Borderless,
		Fullscreen
	}
	
	private static FullscreenOptions _fullscreenMode;


	public override void _Ready()
	{
		LoadSettings();

		foreach (var (controlNodePath, feature) in Features)
		{
			var controlNode = GetNode(controlNodePath);
			ConfigureFeature(feature, controlNode);
		}
	}

	protected void SaveSetting(StringName setting, Variant value)
	{
		Script saveManager = Utils.GetSaveManager();
		if (value.VariantType.ToString().Contains("Vector"))
		{
			// value = value.VariantType.ToString().Contains("I") ? value.ToString().Remove('I'): value.VariantType.ToString();
			value = value.VariantType + " " + value;
		}

		// Log($"Writing: {value}", this);
		saveManager.Callv("write_setting", [setting, value]);
		
	}
	
	protected T ReadSetting<[MustBeVariant] T> (StringName setting)
	{
		Script saveManager = Utils.GetSaveManager();
		Variant varSetting = GD.StrToVar(saveManager.Callv("read_setting", [setting, false]).ToString());
		return varSetting.As<T>();
	}

	private void ConfigureFeature(ControlFeatures feature, Node controlNode)
	{
		switch (feature)
		{
			case ControlFeatures.ResolutionH:
				if (controlNode is LineEdit lineEdit)
				{
					lineEdit.Text = GetWindow().Size.Y + "";
					lineEdit.TextSubmitted += text =>
					{ 
						SetResolution(height: text.ToInt());
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
					// fullscreenButton.Text = "Fullscreen Mode";
					fullscreenButton.ItemSelected += index =>
					{
						SetFullscreen((FullscreenOptions)index);
					};
					fullscreenButton.Selected = (char) _fullscreenMode;
				}
				break;
			case ControlFeatures.VSync:
				if (controlNode is OptionButton vsyncButton)
				{
					foreach (var vsyncMode in Enum.GetValues(typeof(VSyncMode)))
					{
						vsyncButton.AddItem(vsyncMode.ToString());
					}
					// vsyncButton.Text = "VSync Mode";
					vsyncButton.ItemSelected += index =>
					{
						SetVSync((VSyncMode)index);
					};
					vsyncButton.Selected = (char) WindowGetVsyncMode();
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
						// SceneManager.ChangeScene( this,"res://scenes/menus/Settings.tscn");
						core.SceneManager.ReturnToScene(this);
					};
				}
				break;
			case ControlFeatures.ApplyButton:
				if (controlNode is Godot.Button applyButton)
				{
					applyButton.Pressed += WriteSettings;
				}
				break;
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
		//Log($"Changing res: width? {width != null}", this);
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
			
			if (height != null && height >= 0)
			{
				window.Size = new Vector2I((int)width, (int)height);
			}
			else
			{
				window.Size = new Vector2I((int)width, window.Size.Y);
			}
		}
	}

	public void SetFullscreen(FullscreenOptions mode)
	{
		_fullscreenMode = mode;
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

	private void WriteSettings()
	{
		Log("Writing Settings", this);
		SaveSetting("Resolution", (Vector2)GetWindow().Size);
		SaveSetting(nameof(ControlFeatures.Fullscreen), (int)_fullscreenMode);
		SaveSetting(nameof(ControlFeatures.FrameCap), Engine.MaxFps);
		SaveSetting(nameof(ControlFeatures.VSync), (int)WindowGetVsyncMode());
	}

	public virtual void LoadSettings()
	{
		var resolution = ReadSetting<Vector2I>("Resolution");
		SetResolution(resolution.X, resolution.Y);
		SetFullscreen((FullscreenOptions)ReadSetting<int>(nameof(ControlFeatures.Fullscreen)));
		SetFrameCap(ReadSetting<int>(nameof(ControlFeatures.FrameCap)));
		SetVSync((VSyncMode)ReadSetting<int>(nameof(ControlFeatures.VSync)));
	}

	public virtual void LoadDefaults()
	{ 
		var res = ScreenGetUsableRect((int)ScreenPrimary).Size;
		SetResolution(res.X, res.Y);
		SetFullscreen(FullscreenOptions.Fullscreen);
		SetFrameCap(0);
		SetVSync(VSyncMode.Enabled);
	}
}
