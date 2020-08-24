//=============================================================================
// ZoneSatellite.
//=============================================================================
class ZoneSatellite expands Info;

//#exec Texture Import File=ZoneSatellite.pcx Name=ZoneSatellite Mips=On Flags=2

var() bool bActive;
var() name DynamicZoneTag;

function Trigger(Actor Other, Pawn Instigator)
{
	bActive = !bActive;
}

defaultproperties
{
     bActive=True
     Style=STY_Masked
     Texture=Texture'Aeons.ZoneSatellite'
}
