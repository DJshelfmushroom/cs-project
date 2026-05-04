using Godot;
using System;
using Godot.Collections;

public partial class SoundManager : Node
{
	public AudioStreamPlayer MusicPlayer;
	private static readonly Dictionary<string, AudioStream> _cache = new();
	
	// public override void _Process(double delta)
	// {
	// 	
	// }
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
        ((SceneTree)Engine.GetMainLoop()).Root.AddChild(player);
        player.Play();
        player.Finished += () => player.QueueFree();
    }
}
