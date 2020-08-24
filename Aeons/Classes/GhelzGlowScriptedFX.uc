//=============================================================================
// GhelzGlowScriptedFX. 
//=============================================================================
class GhelzGlowScriptedFX expands GlowScriptedFX;

function BeginPlay()
{
	Super.BeginPlay();
	SetTimer(2,false);
}

function Timer()
{
	Destroy();
}

defaultproperties
{
     SizeWidth=(Base=4)
     SizeLength=(Base=4)
     Textures(0)=Texture'Aeons.Particles.Glow01'
}
