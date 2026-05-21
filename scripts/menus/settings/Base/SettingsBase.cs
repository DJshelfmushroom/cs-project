#nullable enable
using System;
using System.Collections.Generic;
using static csproject.scripts.core.Utils;
using csproject.scripts.core;
using Godot;

namespace csproject.scripts.menus.settings.Base;


public abstract partial class SettingsBase<[MustBeVariant]TEnum>: Control where TEnum: struct, Enum 
{
	public abstract TEnum featureEnum { get; }
// #pragma warning disable GD0102
// #pragma warning disable GD0302
	public Godot.Collections.Dictionary<NodePath, TEnum> FeatureNodes;
// #pragma warning restore GD0302
// #pragma warning restore GD0102

	internal static StringName ClassName;
	protected const char Delimiter = '.';
	
	// public Dictionary<TEnum, Variant> FeatureValues;
	public Dictionary<TEnum, Feature> Features = new ();

	public struct Feature(TEnum enumValue, Variant defaultValue, Action<Variant> onSetValue, Type? optionsEnum)
	{
		// this.className = className; 
		public Feature(TEnum name, Action<Variant> onPress) : this(name, "back", onPress, null)
		{
		}

		public Feature(TEnum enumValue, Variant defaultValue, Action<Variant> onSetValue) : this(enumValue, defaultValue, onSetValue,
			null)
		{
		}

		// private readonly StringName className;
		public readonly TEnum EnumValue = enumValue;
		public Type? OptionsEnum = optionsEnum;
		public readonly String GetName() => EnumValue.ToString();
		public override string ToString() => GetName();
		public readonly Type GetValueType() => defaultValue.VariantType.GetType(); 
		public readonly Variant.Type GetVariantType() => defaultValue.VariantType;
		private Variant _value = defaultValue;
		public string description { set; get; } //TODO show description when hovering over a button

		public readonly Variant GetValue()
		{
			return _value;
		}

		public void SetValue(Variant set)
		{
			// Utils.Logger.Log($"Setting Feature Value: {set}", GetMemName());
			this._value = set;
			// Utils.Logger.Log($"Post set Value: {_value}", GetMemName());
			onSetValue.Invoke(_value);
			SaveToMemory();
		}

		public Variant defaultValue { get; } = defaultValue;

		private readonly StringName GetMemName() => ClassName + Delimiter + GetName();

		public void SaveToMemory()
		{
			Script saveManager = GetSaveManager();
			String write = GD.VarToStr(GetValue());
			Utils.Logger.Log($"Setting to write: {GetMemName()}, value: {GetValue()}", "Settings/Feature");
			saveManager.Callv("write_setting", [GetMemName(), write]);
		}

		public void LoadFromMemory()
		{
			Script saveManager = GetSaveManager();
			string settingOut = saveManager.Callv("read_setting", [GetMemName(), false]).ToString();
			_value = GD.StrToVar(settingOut);
			// Utils.Logger.Log($"Load from memory VarType: {_value.VariantType}", "Settings/Feature");
		}
	}
	
	protected void Log(string message, Utils.Logger.LogType logType = Utils.Logger.LogType.Debug)
	{
		Utils.Logger.Log(message, this, logType);
	}

	public override void _Ready()
	{
		ClassName = GetType().Name;
		SetupFeatures();
		LoadSettings();
		foreach (var (controlNodePath, feature) in FeatureNodes)
		{
			var controlNode = GetNode(controlNodePath);
			ConfigureFeature(feature, controlNode);
		}
	}

	protected void ConfigureFeature(TEnum featureEnumVal, Node controlNode)
	{
		Feature feature = Features[featureEnumVal];
		feature.LoadFromMemory();
		switch (controlNode)
		{
			case TextEdit textEdit:
				textEdit.Text = feature.GetValue().AsString();
				textEdit.TextChanged += () =>
				{
					string text = textEdit.Text;
					// feature.SetValue(GD.StrToVar(text.Text));
					Type featureValueType = feature.GetValueType();
					var fullName = GD.StrToVar(text).VariantType.GetType().FullName;
					if (fullName != null && fullName.Equals(featureValueType.FullName))
					{
						feature.SetValue(GD.StrToVar(text));
					}
				};
				break;
			case LineEdit lineEdit:
				lineEdit.Text = feature.GetValue().AsString();
				lineEdit.TextSubmitted += text =>
				{
					Type featureValueType = feature.GetValueType();
					var fullName = GD.StrToVar(text).VariantType.GetType().FullName;
					if (fullName != null && fullName.Equals(featureValueType.FullName))
					{
						feature.SetValue(GD.StrToVar(text));
					}
				};
				break;
			case OptionButton options:
				// options.Toggled += on =>
				// {
				// 	feature.SetValue(on);
				// };
				if (feature.OptionsEnum == null)
				{
					throw new ArgumentNullException();
					// break;
				}

				// Log($"type of optionsEnum: {feature.OptionsEnum.FullName}");
				foreach (var item in Enum.GetNames(feature.OptionsEnum))
				{
					if (item.Equals("Max")) continue;
					options.AddItem(item);
				}

				options.Selected = feature.GetValue().AsInt16();
				options.ItemSelected += index =>
				{
					feature.SetValue(index);
				};
				break;
			case CheckBox checkBox:
				checkBox.SetToggleMode(feature.GetValue().AsBool());
				checkBox.Toggled += on =>
				{
					feature.SetValue(on);
				};
				break;
			case CheckButton checkButton:
				checkButton.SetToggleMode(feature.GetValue().AsBool());
				checkButton.Toggled += on =>
				{
					feature.SetValue(on);
				};
				break;
			case Slider slider:
				slider.DragEnded += changed =>
				{
					if (!changed) return;
					feature.SetValue(slider.Value);
				};
				break;
			case Godot.Button button:
				button.Pressed += () =>
				{
					feature.SetValue(true); // this is to be handled by the feature
				};
				break;
		}

		Features[featureEnumVal] = feature;
	}

	protected virtual void SetupFeatures()
	{
		// set up all the feature (struct)s and add them to the dict
	}

	public void WriteSettings(Variant ignored)
	{
		// foreach (Feature feature in Features.Values)
		// {
		// 	feature.SaveToMemory();
		// }
		Log("placeholder function", Utils.Logger.LogType.Warning);
	}

	public void LoadSettings()
	{
		// Log("LoadSettings not implemented", Utils.Logger.LogType.Error);
		foreach (var feature in Features.Values)
		{
			feature.LoadFromMemory();
		}
	}

	public void LoadDefaults()
	{
		// Log("LoadDefaults not implemented", Utils.Logger.LogType.Error);
		foreach (var feature in Features.Values)
		{
			feature.SetValue(feature.defaultValue);
			feature.SaveToMemory();
		}
	}
}
