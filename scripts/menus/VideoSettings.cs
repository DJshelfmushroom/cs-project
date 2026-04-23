using System;
using System.Diagnostics;
using System.Reflection.Metadata;
using Godot;
using Godot.Collections;
using static csproject.scripts.core.Utils.Logger;

namespace csproject.scripts.menus;

public partial class VideoSettings : Control
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
		FrameCap // linedit or optionbutton
	}
	
	enum FullscreenOptions
	{
		Windowed,
		Borderless
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
						lineEdit.TextSubmitted += text => SetResolution(height:text.ToInt());
						lineEdit.SetMeta("editing", false);
						lineEdit.EditingToggled += editing => { lineEdit.SetMeta("editing", editing); };
					}
					break;
				case ControlFeatures.ResolutionW:
					if (controlNode is LineEdit lineEdit1)
					{
						lineEdit1.Text = GetWindow().Size.X + "";
						lineEdit1.TextSubmitted += text => SetResolution(text.ToInt()); 
						lineEdit1.SetMeta("editing", false);
						lineEdit1.EditingToggled += editing => { lineEdit1.SetMeta("editing", editing); };
					}
					break;
				case ControlFeatures.Fullscreen:
					
					break;
				case ControlFeatures.VSync:
					break;
				case ControlFeatures.FrameCap:
					break;
			}
		}
	}

	public override void _PhysicsProcess(double delta)
	{
		base._PhysicsProcess(delta);
		foreach (var (controlNodePath, feature) in Features)
		{
			var controlNode = GetNode(controlNodePath);
			switch (feature)
			{
				// case ControlFeatures.Fullscreen:
				// 	if (controlNode is OptionButton optionButton)
				// 	{
				// 		optionButton.Selected = GetWindow().Borderless ? 1 : 0;
				// 		optionButton.ItemSelected += index =>
				// 		{
				// 			GetWindow().Borderless = index == 1;
				// 		};
				// 	}
				// 	break;
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
		if (width == null)
		{
			if (height == null)
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

}
