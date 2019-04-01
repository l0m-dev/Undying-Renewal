//=============================================================================
// SlomoInfo.
//=============================================================================
class SlomoInfo expands Info;

#exec TEXTURE IMPORT FILE=SloMo.pcx GROUP=System Mips=Off Flags=2

var() float NewSloMo;

function Trigger(Actor Other, Pawn Instigator)
{
	Level.TimeDilation = NewSloMo;
}

defaultproperties
{
     NewSloMo=1
     Texture=Texture'Aeons.System.SloMo'
}
