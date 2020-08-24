//=============================================================================
// PhoenixParticleFX. 
//=============================================================================
class PhoenixParticleFX expands SpellParticleFX;

var() color StartColor[5];
var() color EndColor[5];

function setup()
{
	ColorStart.base = StartColor[castingLevel];
	ColorEnd.base = EndColor[castingLevel];
}

defaultproperties
{
     StartColor(0)=(R=243,G=255,B=23)
     StartColor(1)=(R=255,G=250,B=23)
     StartColor(2)=(R=243,G=254,B=46)
     StartColor(3)=(R=243,G=255,B=28)
     StartColor(4)=(R=250,G=255,B=34)
     EndColor(0)=(R=255,G=13,B=13)
     EndColor(1)=(R=255,G=112,B=6)
     EndColor(2)=(R=254,G=183,B=35)
     EndColor(3)=(R=226,G=255,B=21)
     EndColor(4)=(R=255,G=255,B=255)
     ParticlesPerSec=(Base=32)
     AngularSpreadWidth=(Base=90)
     AngularSpreadHeight=(Base=90)
     Speed=(Base=20,Rand=50)
     Lifetime=(Base=0.25,Rand=1.5)
     ColorStart=(Base=(G=207))
     AlphaStart=(Base=0.25,Rand=0.75)
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Rand=3)
     Textures(0)=Texture'Aeons.Particles.Flare'
}
