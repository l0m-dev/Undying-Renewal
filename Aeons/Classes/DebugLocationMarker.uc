//=============================================================================
// DebugLocationMarker.
//=============================================================================
class DebugLocationMarker expands Actor;

//#exec TEXTURE IMPORT NAME=DebugMarker FILE=DebugMarker.pcx GROUP=System Mips=Off Flags=2

function PreBeginPlay()
{
     if (Level.NetMode != NM_Standalone && bHidden)
     {
          // needs to be relevant in cutscenes so LookAt works
          // another solution is to set bAlwaysRelevant when we set a LookAt actor in a cutscene
          bHidden = false;
          DrawType = DT_None;
     }
}

defaultproperties
{
     Style=STY_Translucent
     Texture=Texture'Aeons.System.DebugMarker'
     RemoteRole=ROLE_DumbProxy
     NetUpdateFrequency=4
}
