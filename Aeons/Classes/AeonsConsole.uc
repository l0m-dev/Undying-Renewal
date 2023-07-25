//=============================================================================
// AeonsConsole.
//=============================================================================
class AeonsConsole expands WindowConsole;

var bool bRequestedBook;
var bool bRequestWindow;

function RequestBook(Pawn P)
{
	Aeonsplayer(P).ShowBook();
}

event Tick( float Delta )
{
	Super.Tick(Delta);
     if (bRequestWindow || bRequestedBook)
     {
          LaunchUWindow();
          // don't reset bRequestedBook
          bRequestWindow = false;
     }
}

defaultproperties
{
     ShowDesktop=True
     UWindowKey=IK_None
}
