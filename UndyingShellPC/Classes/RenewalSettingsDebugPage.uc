class RenewalSettingsDebugPage extends RenewalSettingsBasePage;

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

	DebugCheck.bChecked = RenewalConfig.bDebug;
	Debug2Check.bChecked = RenewalConfig.bDebug2;
	DebugSlider.Value = RenewalConfig.fDebug;
	Debug2Slider.Value = RenewalConfig.fDebug2;
	DebugEditBox.SetValue(TrimFloat(RenewalConfig.fDebug, 2));
	Debug2EditBox.SetValue(TrimFloat(RenewalConfig.fDebug2, 2));

	//if (RenewalConfig.HudScale == 1.0)
	//	HudSizeCombo.SetSelectedIndex(1);
	//else if (RenewalConfig.HudScale < 1.0)
	//	HudSizeCombo.SetSelectedIndex(0);
	//else
	//	HudSizeCombo.SetSelectedIndex(2);
}

function Notify(UWindowDialogControl C, byte E)
{
	RenewalConfig = GetPlayerOwner().GetRenewalConfig(); // don't cache this, otherwise changes only apply on map change
	
	switch(E)
	{
	//DE_EnterPressed
	case DE_Change:
		switch(C)
		{
		case DebugCheck:
			RenewalConfig.bDebug = DebugCheck.bChecked;
			break;
		case Debug2Check:
			RenewalConfig.bDebug2 = Debug2Check.bChecked;
			break;
		case DebugSlider:
			RenewalConfig.fDebug = DebugSlider.GetValue();
			DebugEditBox.SetValue(TrimFloat(RenewalConfig.fDebug, 2));
			break;
		case Debug2Slider:
			RenewalConfig.fDebug2 = Debug2Slider.GetValue();
			Debug2EditBox.SetValue(TrimFloat(RenewalConfig.fDebug2, 2));
			break;
		case DebugEditBox:
			RenewalConfig.fDebug = float(DebugEditBox.GetValue());
			DebugSlider.Value = RenewalConfig.fDebug;
			//DebugSlider.SetValue(RenewalConfig.fDebug, True);
			break;
		case Debug2EditBox:
			RenewalConfig.fDebug2 = float(Debug2EditBox.GetValue());
			Debug2Slider.Value = RenewalConfig.fDebug2;
			//Debug2Slider.SetValue(RenewalConfig.fDebug2, True);
			break;
		//case HudSizeCombo:
		//	RenewalConfig.HudScale = float(HudSizeCombo.GetValue2());
		//	break;
		}
		break;
	}

	Super.Notify(C, E);
}

defaultproperties
{
}
