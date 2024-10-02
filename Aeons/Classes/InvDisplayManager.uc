//=============================================================================
// InvDisplayManager.
//=============================================================================
class InvDisplayManager expands PlayerManager;

function Ping()
{
	AeonsPlayer(Owner).bDrawInvList = true;
	setTimer(2,false);
}

function Timer()
{
	AeonsPlayer(Owner).bDrawInvList = false;
}

defaultproperties
{
     RemoteRole=ROLE_None
}
