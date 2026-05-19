using System;
using System.Collections.Generic;
using static csproject.scripts.core.Utils;
using csproject.scripts.core;
using Godot;

namespace csproject.scripts.menus.settings.Base;

// public enum FeatureEnum
// {
// }

public abstract partial class SettingsBase<TEnum>: Control where TEnum: struct, Enum 
{

    // public Enum FeatureEnum = (Enum)Enum.Parse(typeof(SettingsEnums.VideoFeatures), nameof(SettingsEnums.VideoFeatures)); 
    public abstract TEnum FeatureEnum { get; }
#pragma warning disable GD0102
    [Export] public Dictionary<NodePath, TEnum> FeatureNodes;
#pragma warning restore GD0102

    protected StringName ClassName;
    protected const char delimiter = '.';
    
    public Dictionary<TEnum, Variant> FeatureValues;
    
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
        saveManager.Callv("write_setting", [ClassName + delimiter + setting, value]);
    }
    
    protected T ReadSetting<[MustBeVariant] T> (StringName setting)
    {
        Script saveManager = Utils.GetSaveManager();
        string settingOut = saveManager.Callv("read_setting", [ClassName + delimiter+ setting, false]).ToString();
        settingOut = settingOut.Substring(settingOut.LastIndexOf(delimiter) + 1);
        Variant varSetting = GD.StrToVar(settingOut);
        return varSetting.As<T>();
    }

    public override void _Ready()
    {
        ClassName = this.GetType().Name;
        LoadSettings();
        foreach (var (controlNodePath, feature) in FeatureNodes)
        {
            var controlNode = GetNode(controlNodePath);
            ConfigureFeature(feature, controlNode);
        }
    }

    protected virtual void ConfigureFeature(TEnum feature, Node controlNode)
    {
        Log("ConfigureFeature not implemented", Utils.Logger.LogType.Error);
    }

    public void WriteSettings()
    {
        Log("WriteSettings not implemented", Utils.Logger.LogType.Error);
        foreach (var featurePair in FeatureValues)
        {
            var feature = featurePair.Key;
            var value = featurePair.Value;
            string featureName = feature.ToString();
            SaveSetting(featureName, value);
        }
    }
    public virtual void ReadSettings()
    {
        Log("ReadSettings not implemented", Utils.Logger.LogType.Error);
    }

    public virtual void LoadSettings()
    {
        Log("LoadSettings not implemented", Utils.Logger.LogType.Error);
    }

    public virtual void LoadDefaults()
    {
        Log("LoadDefaults not implemented", Utils.Logger.LogType.Error);
    }
}