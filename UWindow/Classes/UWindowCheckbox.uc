//=============================================================================
// UWindowCheckbox - a checkbox
//=============================================================================
class UWindowCheckbox extends UWindowButton;

var bool		bChecked;

function BeforePaint(Canvas C, float X, float Y)
{
	LookAndFeel.Checkbox_SetupSizes(Self, C);
	Super.BeforePaint(C, X, Y);
}

function Paint(Canvas C, float X, float Y)
{
	local float oldW;
	LookAndFeel.Checkbox_Draw(Self, C);

	oldW = WinWidth;
	if (bStretched)
		WinWidth = WinHeight;
	Super.Paint(C, X, Y);
	WinWidth = oldW;
}


function LMouseUp(float X, float Y)
{
	if(!bDisabled)
	{	
		bChecked = !bChecked;
		Notify(DE_Change);
	}
	
	Super.LMouseUp(X, Y);
}


function Notify(byte E)
{

	if(NotifyWindow2 != None)
	{
		NotifyWindow(NotifyWindow2).Notify(self, E);
	}
	else 
		Super.Notify(E);
}

defaultproperties
{
}
