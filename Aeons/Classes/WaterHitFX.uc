//=============================================================================
// WaterHitFX. 
//=============================================================================
class WaterHitFX expands HitFX;

var() sound HitSounds[3];
var int i;
var vector v;

function PreBeginPlay()
{
	super.PreBeginPlay();
	Spawn(class 'WaterRing',,,Location + vect(0,0,2), rotator(vect(0,0,1)));
	
	PlaySound(HitSounds[Rand(3)],,1.0,,4096);
	
	/*
	for (i=0; i<4; i++)
	{
		v = VRand() * 32;
		v.z = FRand() * 2.0;
		spawn(class 'WaterRingSmall',,,Location + v, rotator(vect(0,0,1)));
	}
	*/
}

defaultproperties
{
     HitSounds(0)=Sound'Impacts.SurfaceSpecific.E_Imp_Water01'
     HitSounds(1)=Sound'Impacts.SurfaceSpecific.E_Imp_Water02'
     HitSounds(2)=Sound'Impacts.SurfaceSpecific.E_Imp_Water03'
     ParticlesPerSec=(Base=2048)
     SourceWidth=(Base=0)
     SourceHeight=(Base=0)
     AngularSpreadWidth=(Base=10)
     AngularSpreadHeight=(Base=10)
     Speed=(Base=100,Rand=300)
     Lifetime=(Base=0.25,Rand=0.25)
     ColorStart=(Base=(R=187,G=196,B=255))
     ColorEnd=(Base=(G=255,B=255))
     SizeWidth=(Base=4,Rand=4)
     SizeLength=(Base=2)
     Gravity=(Z=-950)
     ParticlesMax=16
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
     RenderPrimitive=PPRIM_Liquid
}
