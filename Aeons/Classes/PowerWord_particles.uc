//=============================================================================
// PowerWord_particles. 
//=============================================================================
class PowerWord_particles expands SpellParticleFX;


function Tick(float DeltaTime)
{
	if ( (Owner == none) && !bShuttingDown )
		GotoState('Release');
}

state Release
{

	function BeginState()
	{
		Shutdown();
		Attraction = vect(0,0,0);

	}
}

defaultproperties
{
     ParticlesPerSec=(Base=64)
     SourceWidth=(Base=8)
     SourceHeight=(Base=8)
     SourceDepth=(Base=8)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=40)
     ColorStart=(Base=(G=255,B=255))
     ColorEnd=(Base=(G=255,B=255))
     AlphaEnd=(Base=1)
     SizeWidth=(Base=2)
     SizeLength=(Base=1.25)
     SizeEndScale=(Base=2)
     bSystemRelative=True
     Attraction=(X=-8,Y=-8,Z=-8)
     Textures(0)=Texture'Aeons.Particles.pw_bit'
     RenderPrimitive=PPRIM_Liquid
     Style=STY_AlphaBlend
}
