//=============================================================================
// UBrowserJoinPW.
//=============================================================================
class UBrowserJoinPW expands UWindowFramedWindow;

var UBrowserJoinPWD EditArea;

function Created()
{
	Super.Created();
	EditArea = UBrowserJoinPWD(ClientArea);
}

defaultproperties
{
	EditArea=None
	ClientClass=Class'UBrowser.UBrowserJoinPWD'
}
