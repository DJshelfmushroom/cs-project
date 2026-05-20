using Godot;
using System;


namespace csproject.scripts.menus.settings;

public enum FeatureEnum
{
    
}

public partial class GraphicsSettings : Base.SettingsBase<FeatureEnum>
{
    public override FeatureEnum FeatureEnum => FeatureEnum;


}
