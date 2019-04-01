//=============================================================================
// AeonsConsole.
//=============================================================================
class AeonsConsole expands WindowConsole;

var bool bRequestedBook;


function RequestBook(Pawn P)
{
	Aeonsplayer(P).ShowBook();
}

defaultproperties
{
     ShowDesktop=True
     UWindowKey=IK_None
}
