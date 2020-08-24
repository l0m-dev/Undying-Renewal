//=============================================================================
// PWScriptedFX. 
//=============================================================================
class PWScriptedFX expands LightningScriptedFX;

function Tick(float DeltaTime);

defaultproperties
{
     SizeWidth=(Base=4)
     SizeLength=(Base=4)
     bSystemRelative=False
     Textures(0)=Texture'Aeons.Particles.pw_trail'
}
