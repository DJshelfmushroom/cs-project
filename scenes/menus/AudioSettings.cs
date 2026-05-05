using Godot.Collections;
using csproject.scripts.menus;
using Godot;
using static csproject.scripts.core.Utils.Logger;

namespace csproject.scenes.menus;

public partial class AudioSettings : VideoSettings
{
	[Export] private new Dictionary<NodePath, ControlFeatures> Features;

	private enum ControlFeatures
	{
		BackButton,
		MusicSelect
	}

	private enum Music
	{
		throatSing,
		none
	}

	public override void _Ready()
	{
		foreach (var (controlNodePath, feature) in Features)
		{
			var controlNode = GetNode(controlNodePath);
			Log($"Audio Feature: {feature}", this);
			ConfigureAudioFeature(feature, controlNode);
		}
	}

	private void ConfigureAudioFeature(ControlFeatures feature, Node controlNode)
	{
		switch (feature)
		{
			case ControlFeatures.BackButton:
				if (controlNode is Godot.Button button)
				{
					button.Pressed += () => GetTree().ChangeSceneToFile("res://scenes/menus/Settings.tscn");
				}
				break;
			case ControlFeatures.MusicSelect:
				if (controlNode is Godot.OptionButton musicSelectButton)
				{
					musicSelectButton.ItemSelected += (index) => ChangeMusic((Music)index);
				}
				break;
		}
	}

	private void ChangeMusic(Music index)
	{
		return;
	}
	public override void _Process(double delta)
	{
	}
}