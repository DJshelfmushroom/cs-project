using Godot;
using System;
using Godot.Collections;

public partial class SoundManager : Node
{
	public static AudioStreamPlayer MusicPlayer;
	private static readonly Dictionary<string, AudioStream> _cache = new();
	
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
        player.Finished += () => player.QueueFree();
    }

    public override void _Ready()
	{
	    MusicPlayer = new AudioStreamPlayer();
	    MusicPlayer.Bus = "Music";
	}
    public static void PlayMusic(string path)
    {
	    AudioStreamPlayer player = MusicPlayer;
	    player.Stream = GD.Load<AudioStream>(path);
        var root = ((SceneTree)Engine.GetMainLoop()).Root;
        root.CallDeferred(Node.MethodName.AddChild, player);
        player.CallDeferred(AudioStreamPlayer.MethodName.Play);
    }
}
