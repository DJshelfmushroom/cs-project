using csproject.scripts.core;
using Godot.Collections;
using csproject.scripts.menus;
using Godot;
using System;
using static csproject.scripts.core.Utils.Logger;
using static csproject.SoundManager;

namespace csproject.scripts.menus.settings;

public partial class AudioSettings : VideoSettings
{
	[Export] private Dictionary<NodePath, ControlFeatures> Features;

	private enum ControlFeatures
	{
		BackButton,
		MusicSelect,
		VolumeSlider,
	}

	private float Volume;
	private bool loading = false;
	
	public override void _Ready()
	{
		// base._Ready(); // Can we discuss how to make this work?
		LoadSettings();
		foreach (var (controlNodePath, feature) in Features)
		{
			var controlNode = GetNode(controlNodePath);
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
					// button.Pressed += () => GetTree().ChangeSceneToFile("res://scenes/menus/Settings.tscn");
					button.Pressed += () => // Feel free to change this back. I personally prefer an apply button (for consistency's sake).
					{
						SceneManager.ReturnToScene(this);
						WriteSettings();
					};
				}
				break;
			case ControlFeatures.MusicSelect:
				if (controlNode is OptionButton musicSelectButton)
				{
					musicSelectButton.ItemSelected += (index) => ChangeMusic(GetMusicForIndex(musicSelectButton, index));
					SelectCurrentMusic(musicSelectButton);
				}
				break;
			case ControlFeatures.VolumeSlider:
				if (controlNode is HSlider slider)
				{
					slider.ValueChanged += (volume) => ChangeVolume((float)volume);
					slider.Value = Volume;
				}
				break;
		}
	}

	private static Music GetMusicForIndex(OptionButton musicSelectButton, long index)
	{
		var itemIndex = (int)index;
		if (itemIndex < 0 || itemIndex >= musicSelectButton.ItemCount)
		{
			return Music.None;
		}

		var id = musicSelectButton.GetItemId(itemIndex);
		return Enum.IsDefined(typeof(Music), id) ? (Music)id : Music.None;
	}

	private static void SelectCurrentMusic(OptionButton musicSelectButton)
	{
		for (var i = 0; i < musicSelectButton.ItemCount; i++)
		{
			if (musicSelectButton.GetItemId(i) == (int)SoundManager.NowPlaying)
			{
				musicSelectButton.Selected = i;
				return;
			}
		}

		if (musicSelectButton.ItemCount > 0)
		{
			musicSelectButton.Selected = 0;
		}
	}

	private void ChangeMusic(Music music)
	{
		Utils.Logger.Log($"Attempting to change music to {music}", this);
		SoundManager.PlayMusic(music);
		Utils.Logger.Log($"Music is {NowPlaying}", this);
		Log($"Player says playing: {MusicPlayer.Playing}", this);
		// WriteSettings();
	}

	private void ChangeVolume(float volume)
	{
		Utils.Logger.Log($"Changing volume to {volume}, DB: {Mathf.LinearToDb(volume)}", this);
		AudioServer.SetBusVolumeDb(0, Mathf.LinearToDb(volume));
		Volume = volume;
	}
	public override void _Process(double delta)
	{
	}
	private void WriteSettings()
	{
		// Utils.Logger.Log("Writing audio Settings", this);
		SaveSetting("Music", (int)NowPlaying);
		SaveSetting("Volume", Volume);
	}

	public override void LoadSettings()
	{
		if (loading) return;
		loading = true;
		var savedMusic = ReadSetting<int>("Music");
		ChangeMusic(Enum.IsDefined(typeof(Music), savedMusic) ? (Music)savedMusic : Music.None);
		var savedVolume = ReadSetting<int>("Volume");
		ChangeVolume(savedVolume);
		loading = false;
	}

	public override void LoadDefaults()
	{
		NowPlaying = Music.ThroatSing;
		ChangeVolume(1f);
		CallDeferred(nameof(WriteSettings));
	}

}
