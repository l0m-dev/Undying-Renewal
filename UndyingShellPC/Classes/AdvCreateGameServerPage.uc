class AdvCreateGameServerPage extends UMenuRenewalBasePage;

var UWindowEditControl AdminEMailEdit;
var UWindowEditControl AdminNameEdit;
var UWindowEditControl MOTDLine1Edit;
var UWindowEditControl MOTDLine2Edit;
var UWindowEditControl MOTDLine3Edit;
var UWindowEditControl MOTDLine4Edit;
var UWindowEditControl ServerNameEdit;
var UWindowCheckbox DoUplinkCheck;
var UWindowCheckbox ngWorldStatsCheck;
var UWindowCheckbox LanPlayCheck;

function Created()
{
	Super.Created();

	ServerNameEdit = UWindowEditControl(AddControl(class'UWindowEditControl', class'UMenuServerSetupPage'.default.ServerNameText, class'UMenuServerSetupPage'.default.ServerNameHelp));
	ServerNameEdit.SetFont(F_Normal);
	ServerNameEdit.SetNumericOnly(False);
	ServerNameEdit.SetMaxLength(205);
	ServerNameEdit.SetDelayedNotify(True);
	ServerNameEdit.EditBoxWidth = 200;

	AdminNameEdit = UWindowEditControl(AddControl(class'UWindowEditControl', class'UMenuServerSetupPage'.default.AdminNameText, class'UMenuServerSetupPage'.default.AdminNameHelp));
	AdminNameEdit.SetFont(F_Normal);
	AdminNameEdit.SetNumericOnly(False);
	AdminNameEdit.SetMaxLength(205);
	AdminNameEdit.SetDelayedNotify(True);
	AdminNameEdit.EditBoxWidth = 200;
	
	AdminEmailEdit = UWindowEditControl(AddControl(class'UWindowEditControl', class'UMenuServerSetupPage'.default.AdminEmailText, class'UMenuServerSetupPage'.default.AdminEmailHelp));
	AdminEmailEdit.SetFont(F_Normal);
	AdminEmailEdit.SetNumericOnly(False);
	AdminEmailEdit.SetMaxLength(205);
	AdminEmailEdit.SetDelayedNotify(True);
	AdminEmailEdit.EditBoxWidth = 200;

	MOTDLine1Edit = UWindowEditControl(AddControl(class'UWindowEditControl', class'UMenuServerSetupPage'.default.MOTDLine1Text, class'UMenuServerSetupPage'.default.MOTDLine1Help));
	MOTDLine1Edit.SetFont(F_Normal);
	MOTDLine1Edit.SetNumericOnly(False);
	MOTDLine1Edit.SetMaxLength(205);
	MOTDLine1Edit.SetDelayedNotify(True);
	MOTDLine1Edit.EditBoxWidth = 200;

	MOTDLine2Edit = UWindowEditControl(AddControl(class'UWindowEditControl', class'UMenuServerSetupPage'.default.MOTDLine2Text, class'UMenuServerSetupPage'.default.MOTDLine2Help));
	MOTDLine2Edit.SetFont(F_Normal);
	MOTDLine2Edit.SetNumericOnly(False);
	MOTDLine2Edit.SetMaxLength(205);
	MOTDLine2Edit.SetDelayedNotify(True);
	MOTDLine2Edit.EditBoxWidth = 200;

	MOTDLine3Edit = UWindowEditControl(AddControl(class'UWindowEditControl', class'UMenuServerSetupPage'.default.MOTDLine3Text, class'UMenuServerSetupPage'.default.MOTDLine3Help));
	MOTDLine3Edit.SetFont(F_Normal);
	MOTDLine3Edit.SetNumericOnly(False);
	MOTDLine3Edit.SetMaxLength(205);
	MOTDLine3Edit.SetDelayedNotify(True);
	MOTDLine3Edit.EditBoxWidth = 200;

	MOTDLine4Edit = UWindowEditControl(AddControl(class'UWindowEditControl', class'UMenuServerSetupPage'.default.MOTDLine4Text, class'UMenuServerSetupPage'.default.MOTDLine4Help));
	MOTDLine4Edit.SetFont(F_Normal);
	MOTDLine4Edit.SetNumericOnly(False);
	MOTDLine4Edit.SetMaxLength(205);
	MOTDLine4Edit.SetDelayedNotify(True);
	MOTDLine4Edit.EditBoxWidth = 200;
	
	GetSettings();
}

function GetSettings()
{
	Super.GetSettings();

	ServerNameEdit.SetValue(class'Engine.GameReplicationInfo'.default.ServerName);
	AdminNameEdit.SetValue(class'Engine.GameReplicationInfo'.default.AdminName);
	AdminEmailEdit.SetValue(class'Engine.GameReplicationInfo'.default.AdminEmail);
	MOTDLine1Edit.SetValue(class'Engine.GameReplicationInfo'.default.MOTDLine1);
	MOTDLine2Edit.SetValue(class'Engine.GameReplicationInfo'.default.MOTDLine2);
	MOTDLine3Edit.SetValue(class'Engine.GameReplicationInfo'.default.MOTDLine3);
	MOTDLine4Edit.SetValue(class'Engine.GameReplicationInfo'.default.MOTDLine4);
}

function Notify(UWindowDialogControl C, byte E)
{
	RenewalConfig = GetPlayerOwner().GetRenewalConfig(); // don't cache this, otherwise changes only apply on map change
	switch(E)
	{
	case DE_Change:
		switch(C)
		{
		case AdminEMailEdit:
			class'Engine.GameReplicationInfo'.default.AdminEmail = AdminEmailEdit.GetValue();
			break;
		case AdminNameEdit:
			class'Engine.GameReplicationInfo'.default.AdminName = AdminNameEdit.GetValue();
			break;
		case MOTDLine1Edit:
			class'Engine.GameReplicationInfo'.default.MOTDLine1 = MOTDLine1Edit.GetValue();
			break;
		case MOTDLine2Edit:
			class'Engine.GameReplicationInfo'.default.MOTDLine2 = MOTDLine2Edit.GetValue();
			break;
		case MOTDLine3Edit:
			class'Engine.GameReplicationInfo'.default.MOTDLine3 = MOTDLine3Edit.GetValue();
			break;
		case MOTDLine4Edit:
			class'Engine.GameReplicationInfo'.default.MOTDLine4 = MOTDLine4Edit.GetValue();
			break;
		case ServerNameEdit:
			class'Engine.GameReplicationInfo'.default.ServerName = ServerNameEdit.GetValue();
			break;
		//case DoUplinkCheck:
		//	if(DoUplinkCheck.bChecked)
		//		GetPlayerOwner().ConsoleCommand("set IpServer.UdpServerUplink DoUplink True");
		//	else
		//		GetPlayerOwner().ConsoleCommand("set IpServer.UdpServerUplink DoUplink False");
		//	IPServerClass.Static.StaticSaveConfig();
		//	break;
		//case ngWorldStatsCheck:
		//	if (GetLevel().Game != None)
		//	{
		//		GetLevel().Game.bWorldLog = ngWorldStatsCheck.bChecked;
		//		GetLevel().Game.SaveConfig();
		//	}
		//	break;
		//case LanPlayCheck:
		//	bLanPlay = LanPlayCheck.bChecked;
		//	break;
		}
	}

	Super.Notify(C, E);
}

defaultproperties
{
     
}
