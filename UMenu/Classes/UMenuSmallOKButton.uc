class UMenuSmallOKButton extends UMenuSmallCloseButton;

var localized string OKText;

function Created()
{
	Super.Created();
	SetText(OKText);
}

defaultproperties
{
     OKText="OK"
}
