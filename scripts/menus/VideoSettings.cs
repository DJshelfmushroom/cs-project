using System;
using System.Diagnostics;
using Godot;
using Godot.Collections;
using static csproject.scripts.core.Utils.Logger;

namespace csproject.scripts.menus;

public partial class VideoSettings : Container
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
    
    [Export] protected Dictionary<Control, ControlFeatures> Features;
    
    protected enum ControlFeatures
    {
        ResolutionW, //textedit
        ResolutionH, //textedit
        PresetResolution, //OptionButton
        Fullscreen, //optionbutton
        VSync, //optionbutton
        FrameCap // textedit
    }


    public override void _Ready()
    {
        base._Ready();

        foreach (var controlNode in Features.Keys)
        {

            switch (Features[controlNode])
            {
                case ControlFeatures.ResolutionH:
                    break;
                case ControlFeatures.ResolutionW:
                    break;
                case ControlFeatures.PresetResolution:
                    break;
                case ControlFeatures.Fullscreen:
                    break;
                case ControlFeatures.VSync:
                    break;
                case ControlFeatures.FrameCap:
                    break;
            }
#if CHECKTYPE
            
            controlNode.SetMeta("Label", Features[controlNode]);
            
            if (controlNode is Container)
            {
                Log("Contains Container", this);
            }
            else if (controlNode is LineEdit or TextEdit)
            {
                Log("Contains TextEdit", this);
            } 
            else if (controlNode is HSlider or VSlider)
            {
                Log("Contains Slider", this);
            }
            else if (controlNode is CheckButton or CheckBox)
            {
                Log("Contains CheckButton", this);
            }
            else if (controlNode is OptionButton)
            {
                Log("Contains OptionButton", this);
            }
            else if (controlNode is Button)
            {
                Log("Contains Button", this);
            }
            else if (controlNode is HSeparator)
            {
                Log("Contains Separator", this);
            }
            else
            {
                Log($"Settings node {controlNode.Name} of type ({controlNode.GetClass()}) is of a type not yet implemented. Either add it" +
                    $" yourself or use a different node type", this, LogType.Error);
                throw new NotImplementedException();
            }
#endif
        }
    }

    public void SetResolution(int? width, int? height)
    {
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