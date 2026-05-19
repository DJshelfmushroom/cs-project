using static csproject.scripts.core.Utils;
using csproject.scripts.core;
using Godot;

namespace csproject.scripts.menus.settings.Base;

public abstract partial class SettingsBase : Control
{
    protected void Log(string message, Utils.Logger.LogType logType = Utils.Logger.LogType.Debug)
    {
        Utils.Logger.Log(message, this, logType);
    }

    protected void SaveSetting(StringName setting, Variant value)
    {
        Script saveManager = GetSaveManager();
        if (value.VariantType.ToString().Contains("Vector"))
        {
            value = value.VariantType + " " + value;
        }
        saveManager.Callv("write_setting", [setting, value]);
    }
    
    protected T ReadSetting<[MustBeVariant] T> (StringName setting)
    {
        Script saveManager = Utils.GetSaveManager();
        Variant varSetting = GD.StrToVar(saveManager.Callv("read_setting", [setting, false]).ToString());
        return varSetting.As<T>();
    }

    public override void _Ready()
    {
        base._Ready();
        
    }

    public virtual void WriteSettings()
    {
        Log("WriteSettings not implemented", Utils.Logger.LogType.Error);
    }
    public virtual void ReadSettings()
    {
        Log("ReadSettings not implemented", Utils.Logger.LogType.Error);
    }

    public virtual void LoadDefaults()
    {
        Log("LoadDefaults not implemented", Utils.Logger.LogType.Error);
    }
}