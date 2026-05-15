using csproject.scripts.core;
using Godot;
using Godot.Collections;

namespace csproject;

public partial class SoundManager : Node // Ideally this is moved into the core folder
{
	public enum Music
	{
		ThroatSing,
		Techno,
		None
	}

	public static Music NowPlaying;
	
	public static AudioStreamPlayer MusicPlayer;
	private static readonly Dictionary<string, AudioStream> _cache = new();
	private static Music? _pendingMusic = null;
	
	public static void PlaySound(string path)
	{
		// Check if the sound is already in the cache
		if (!_cache.TryGetValue(path, out AudioStream stream))
		{
			// It's not, load it and add it to the cache
			stream = GD.Load<AudioStream>(path);
			_cache[path] = stream;
		}

		// Great. We have the stream either way, now instantiate a player and play it
		AudioStreamPlayer player = new AudioStreamPlayer();
		player.Stream = stream;
		var root = ((SceneTree)Engine.GetMainLoop()).Root;
		root.CallDeferred(Node.MethodName.AddChild, player);
		player.CallDeferred(AudioStreamPlayer.MethodName.Play);
		player.Finished += player.QueueFree;
	}

	public override void _Ready()
	{ 
		EnsureMusicPlayer();
	}

	public static void PlayMusic(Music music)
	{
		if (!EnsureMusicPlayer())
		{
			Utils.Logger.Log("Music player is not ready yet. Queuing request.", "SoundManager");
			_pendingMusic = music;
			return;
		}

		if (music == NowPlaying && MusicPlayer.Playing) return;
		switch (music)
		{
			case Music.ThroatSing:
				MusicPlayer.Stream = GD.Load<AudioStream>("res://throatsing.wav");
				MusicPlayer.Play();
				break;
			case Music.Techno:
				MusicPlayer.Stream = GD.Load<AudioStream>("res://techno.mp3");
				MusicPlayer.Play();
				break;
			case Music.None:
				MusicPlayer.Stop();
				break;
		}
		NowPlaying = music;
		Utils.Logger.Log($"Now Playing: {NowPlaying}", "SoundManager");
	}

	private static bool EnsureMusicPlayer()
	{
		if (MusicPlayer != null)
		{
			return MusicPlayer.IsInsideTree();
		}

		if (Engine.GetMainLoop() is not SceneTree tree || tree.Root == null)
		{
			return false;
		}

		MusicPlayer = new AudioStreamPlayer();
		MusicPlayer.Bus = "Music";
		MusicPlayer.TreeEntered += OnMusicPlayerTreeEntered;
		tree.Root.CallDeferred(Node.MethodName.AddChild, MusicPlayer);
		return false;
	}

	private static void OnMusicPlayerTreeEntered()
	{
		// If there was a pending play request, play it now.
		if (_pendingMusic.HasValue)
		{
			var music = _pendingMusic.Value;
			_pendingMusic = null;
			PlayMusic(music);
		}
		// Unsubscribe to avoid duplicate handling.
		if (MusicPlayer != null)
		{
			MusicPlayer.TreeEntered -= OnMusicPlayerTreeEntered;
		}
	}
	
}