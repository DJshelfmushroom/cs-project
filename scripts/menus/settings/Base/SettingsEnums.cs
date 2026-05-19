namespace csproject.scripts.menus.settings.Base;

public class SettingsEnums
{
    public enum VideoFeatures
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

    public enum GraphicsFeatures
    {
        AntiAliasing,
        AnisotropicFiltering
    }
}

