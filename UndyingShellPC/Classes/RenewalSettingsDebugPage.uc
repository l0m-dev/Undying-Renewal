class RenewalSettingsDebugPage extends UMenuRenewalBasePage;

var UWindowCheckbox DebugCheck;
var UWindowCheckbox Debug2Check;
var UWindowHSliderControl DebugSlider;
var UWindowHSliderControl Debug2Slider;
var UWindowEditControl DebugEditBox;
var UWindowEditControl Debug2EditBox;

function Created()
{
	Super.Created();

	DebugCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', "bDebug", ""));

	Debug2Check = UWindowCheckbox(AddControl(class'UWindowCheckbox', "bDebug2", ""));

	DebugSlider = UWindowHSliderControl(AddControl(class'UWindowHSliderControl', "Debug", ""));
	DebugSlider.SetRange(0, 2, 0.05);
	DebugSlider.SliderWidth = 90;

	DebugEditBox = UWindowEditControl(AddControl(class'UWindowEditControl')); 
	//DebugEditBox.Editbox.NotifyOwner = Self;
	DebugEditBox.Editbox.bTransient = True;
	DebugEditBox.SetNumericOnly(True);
	DebugEditBox.SetNumericFloat(True);
	DebugEditBox.SetDelayedNotify(True);
	//DebugEditBox.SetSize(100, 25);
	DebugEditBox.EditBoxWidth = 50;

	Debug2Slider = UWindowHSliderControl(AddControl(class'UWindowHSliderControl', "Debug2", ""));
	Debug2Slider.SetRange(0, 2, 0.05);
	Debug2Slider.SliderWidth = 90;

	Debug2EditBox = UWindowEditControl(AddControl(class'UWindowEditControl')); 
	//Debug2EditBox.Editbox.NotifyOwner = Self;
	Debug2EditBox.Editbox.bTransient = True;
	Debug2EditBox.SetNumericOnly(True);
	Debug2EditBox.SetNumericFloat(True);
	Debug2EditBox.SetDelayedNotify(True);
	//Debug2EditBox.SetSize(100, 25);
	Debug2EditBox.EditBoxWidth = 50;
	
	//HudSizeCombo = UWindowComboControl(AddControl(class'UWindowComboControl', HudSizeText, HudSizeHelp));
	//HudSizeCombo.EditBoxWidth = 90;
	//HudSizeCombo.SetFont(F_Normal);
	//HudSizeCombo.SetEditable(False);
	//HudSizeCombo.AddItem("Small", "0.75");
	//HudSizeCombo.AddItem("Normal", "1.0");
	//HudSizeCombo.AddItem("Big", "1.25");
	
	GetSettings();
}

function GetSettings()
{
	Super.GetSettings();

	DebugCheck.bChecked = class'RenewalConfig'.default.bDebug;
	Debug2Check.bChecked = class'RenewalConfig'.default.bDebug2;
	DebugSlider.Value = class'RenewalConfig'.default.fDebug;
	Debug2Slider.Value = class'RenewalConfig'.default.fDebug2;
	DebugEditBox.SetValue(TrimFloat(class'RenewalConfig'.default.fDebug, 2));
	Debug2EditBox.SetValue(TrimFloat(class'RenewalConfig'.default.fDebug2, 2));

	//if (class'RenewalConfig'.default.HudScale == 1.0)
	//	HudSizeCombo.SetSelectedIndex(1);
	//else if (class'RenewalConfig'.default.HudScale < 1.0)
	//	HudSizeCombo.SetSelectedIndex(0);
	//else
	//	HudSizeCombo.SetSelectedIndex(2);
}

function Notify(UWindowDialogControl C, byte E)
{
	switch(E)
	{
	//DE_EnterPressed
	case DE_Change:
		switch(C)
		{
		case DebugCheck:
			class'RenewalConfig'.default.bDebug = DebugCheck.bChecked;
			break;
		case Debug2Check:
			class'RenewalConfig'.default.bDebug2 = Debug2Check.bChecked;
			break;
		case DebugSlider:
			class'RenewalConfig'.default.fDebug = DebugSlider.GetValue();
			DebugEditBox.SetValue(TrimFloat(class'RenewalConfig'.default.fDebug, 2));
			break;
		case Debug2Slider:
			class'RenewalConfig'.default.fDebug2 = Debug2Slider.GetValue();
			Debug2EditBox.SetValue(TrimFloat(class'RenewalConfig'.default.fDebug2, 2));
			break;
		case DebugEditBox:
			class'RenewalConfig'.default.fDebug = float(DebugEditBox.GetValue());
			DebugSlider.Value = class'RenewalConfig'.default.fDebug;
			//DebugSlider.SetValue(class'RenewalConfig'.default.fDebug, True);
			break;
		case Debug2EditBox:
			class'RenewalConfig'.default.fDebug2 = float(Debug2EditBox.GetValue());
			Debug2Slider.Value = class'RenewalConfig'.default.fDebug2;
			//Debug2Slider.SetValue(class'RenewalConfig'.default.fDebug2, True);
			break;
		//case HudSizeCombo:
		//	class'RenewalConfig'.default.HudScale = float(HudSizeCombo.GetValue2());
		//	break;
		}
		break;
	}

	Super.Notify(C, E);
}

defaultproperties
{
}
