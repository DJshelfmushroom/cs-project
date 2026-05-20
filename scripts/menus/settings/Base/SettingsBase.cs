using System;
using System.Collections.Generic;
using static csproject.scripts.core.Utils;
using csproject.scripts.core;
using Godot;
using Microsoft.VisualBasic;
using System.Runtime.InteropServices.Marshalling;

namespace csproject.scripts.menus.settings.Base;


public abstract partial class SettingsBase<TEnum>: Control where TEnum: struct, Enum 
{
	public abstract TEnum FeatureEnum { get; }
#pragma warning disable GD0102
	[Export] public Dictionary<NodePath, TEnum> FeatureNodes;
#pragma warning restore GD0102

	protected static StringName ClassName;
	protected const char delimiter = '.';
	
	// public Dictionary<TEnum, Variant> FeatureValues;
	public Dictionary<TEnum, Feature> features;

	public struct Feature
	{
		public Feature(TEnum enumValue, Variant defaultValue, Action onSetValue)
		{
			this.enumValue = enumValue;
			this.defaultValue = defaultValue;
			value = defaultValue;
			// this.className = className; 
			this.onSetValue = onSetValue;
		}
		// private readonly StringName className;
		public readonly TEnum enumValue;
        public readonly String GetName() => enumValue.ToString();
        public override string ToString() => GetName();
		public readonly Type GetValueType() => defaultValue.VariantType.GetType(); 
        private Variant value;

        public readonly Variant GetValue()
        {
            return value;
        }

        public void SetValue(Variant value)
        {
            this.value = value;
			onSetValue.Invoke();
        }

        public readonly Variant defaultValue { get; }
		private Action onSetValue;

		private readonly StringName GetMemName() => ClassName + delimiter + GetName();

		public void SaveToMemory()
		{
			Script saveManager = GetSaveManager();
			if (value.VariantType.ToString().Contains("Vector"))
			{
				value = value.VariantType + " " + value;
			}
			saveManager.Callv("write_setting", [GetMemName(), GD.VarToStr(value)]);
		}

		public void LoadFromMemory()
		{
			Script saveManager = GetSaveManager();
			string settingOut = saveManager.Callv("read_setting", [GetMemName(), false]).ToString();
			value = GD.StrToVar(settingOut);
		}
	}
	
	protected void Log(string message, Utils.Logger.LogType logType = Utils.Logger.LogType.Debug)
	{
		Utils.Logger.Log(message, this, logType);
	}

	public override void _Ready()
	{
		ClassName = this.GetType().Name;
		SetupFeatures();
		LoadSettings();
		foreach (var (controlNodePath, feature) in FeatureNodes)
		{
			var controlNode = GetNode(controlNodePath);
			ConfigureFeature(feature, controlNode);
		}
	}

	protected void ConfigureFeature(TEnum feature, Node controlNode)
	{
		switch (controlNode)
		{
			case TextEdit text:
				break;
			case OptionButton options:
				break;
			case CheckBox checkBox:
				break;
			case CheckButton checkButton:
				break;
			case Slider:
				break;
			case Godot.Button button:
				break;
			
		}
	}

	protected virtual void SetupFeatures()
	{
		// set up all the feature (struct)s and add them to the dict
	}

	public void WriteSettings()
	{
		foreach (Feature feature in features.Values)
		{
			feature.SaveToMemory();
		}
	}

	public void LoadSettings()
	{
		// Log("LoadSettings not implemented", Utils.Logger.LogType.Error);
		foreach (var feature in features.Values)
		{
			feature.LoadFromMemory();
		}
	}

	public void LoadDefaults()
	{
		// Log("LoadDefaults not implemented", Utils.Logger.LogType.Error);
		foreach (var feature in features.Values)
		{
			feature.SetValue(feature.defaultValue);
			feature.SaveToMemory();
		}
	}
}
